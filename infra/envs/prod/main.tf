# Get current Azure client config
data "azurerm_client_config" "current" {}

# Configure Kubernetes and Helm providers after AKS is created
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
}

provider "helm" {}

# Get DNS zone information
data "azurerm_dns_zone" "public" {
  name                = var.dns_zone_name
  resource_group_name = var.dns_zone_rg
}

# Data source for AKS cluster (for provider configuration)
data "azurerm_kubernetes_cluster" "this" {
  name                = module.aks.cluster_name
  resource_group_name = module.aks.cluster_resource_group_name
  depends_on          = [module.aks]
}

# Create Log Analytics workspace
resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-${var.environment}-${replace(var.location, " ", "")}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Main resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-${replace(var.location, " ", "")}"
  location = var.location
  tags     = var.tags
}

# Hub networking
module "hub" {
  source = "../../modules/hub"

  name_prefix    = var.environment
  location       = var.location
  location_short = replace(var.location, " ", "")
  tags           = var.tags
}

# Firewall
module "firewall" {
  source = "../../modules/firewall"

  name_prefix         = var.environment
  location            = var.location
  location_short      = replace(var.location, " ", "")
  resource_group_name = module.hub.resource_group_name
  subnet_id           = module.hub.firewall_subnet_id
  aks_subnet_cidrs = concat(
    ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"],   # AKS system subnets
    ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"] # AKS user subnets
  )
  tags = var.tags
}

# Spoke networking
module "spoke" {
  source = "../../modules/spoke"

  name_prefix             = var.environment
  location                = var.location
  location_short          = replace(var.location, " ", "")
  hub_vnet_id             = module.hub.vnet_id
  hub_vnet_name           = module.hub.vnet_name
  hub_resource_group_name = module.hub.resource_group_name
  firewall_private_ip     = module.firewall.firewall_private_ip
  tags                    = var.tags
}

# NAT Gateway
module "natgw" {
  source = "../../modules/natgw"

  name_prefix           = var.environment
  location              = var.location
  location_short        = replace(var.location, " ", "")
  resource_group_name   = module.spoke.resource_group_name
  aks_system_subnet_ids = module.spoke.aks_system_subnet_ids
  aks_user_subnet_ids   = module.spoke.aks_user_subnet_ids
  tags                  = var.tags
}

# Private DNS
module "private_dns" {
  source = "../../modules/private_dns"

  name_prefix         = var.environment
  location            = var.location
  location_short      = replace(var.location, " ", "")
  resource_group_name = module.hub.resource_group_name
  hub_vnet_id         = module.hub.vnet_id
  spoke_vnet_id       = module.spoke.vnet_id
  tags                = var.tags
}

# Key Vault
module "keyvault" {
  source = "../../modules/keyvault"

  name_prefix         = var.environment
  location            = var.location
  location_short      = replace(var.location, " ", "")
  resource_group_name = module.hub.resource_group_name
  allowed_subnet_ids = concat(
    [module.hub.private_endpoints_subnet_id],
    module.spoke.aks_system_subnet_ids,
    module.spoke.aks_user_subnet_ids
  )
  private_endpoints_subnet_id  = module.hub.private_endpoints_subnet_id
  keyvault_private_dns_zone_id = module.private_dns.keyvault_zone_id
  tags                         = var.tags
}

# Identities
module "identities" {
  source = "../../modules/identities"

  name_prefix         = var.environment
  location            = var.location
  location_short      = replace(var.location, " ", "")
  resource_group_name = module.hub.resource_group_name
  dns_zone_id         = data.azurerm_dns_zone.public.id
  keyvault_id         = module.keyvault.id
  tags                = var.tags
}

# AKS
module "aks" {
  source = "../../modules/aks"

  name_prefix                = var.environment
  location                   = var.location
  location_short             = replace(var.location, " ", "")
  resource_group_name        = module.spoke.resource_group_name
  vnet_subnet_id_system      = module.spoke.aks_system_subnet_ids[0]
  vnet_subnet_id_user        = module.spoke.aks_user_subnet_ids[0]
  private_dns_zone_id        = module.private_dns.aks_api_zone_id
  kubelet_uami_id            = module.identities.kubelet_uami_id
  workload_identity_enabled  = true
  aad_rbac_enabled           = true
  network_plugin             = "azure"
  network_plugin_mode        = "overlay"
  network_policy             = "cilium"
  enable_azure_policy        = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  nodepools = {
    system = {
      vm_size = "Standard_D4s_v5"
      min     = 2
      max     = 5
      zones   = ["1", "2", "3"]
      taints  = ["nodepool=os:NoSchedule"]
    }
    critical = {
      vm_size = "Standard_D8s_v5"
      min     = 3
      max     = 10
      zones   = ["1", "2", "3"]
      taints  = ["workload=critical:NoSchedule"]
    }
    app = {
      vm_size = "Standard_D4s_v5"
      min     = 3
      max     = 15
      zones   = ["1", "2", "3"]
    }
  }

  tags = var.tags
}

# Baseline add-ons
module "baseline" {
  source = "../../modules/baseline"

  cluster_name        = module.aks.cluster_name
  resource_group_name = module.spoke.resource_group_name

  ingress_nginx = {
    internal = true
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }

  cert_manager = {
    email = "ops@${var.dns_zone_name}"
  }

  external_dns = {
    dns_zone_rg    = var.dns_zone_rg
    dns_zone_name  = var.dns_zone_name
    uami_client_id = module.identities.external_dns_client_id
  }

  external_secrets = {
    keyvault_id    = module.keyvault.id
    uami_client_id = module.identities.external_secrets_client_id
  }

  csi_keyvault = {
    uami_client_id = module.identities.csi_keyvault_client_id
  }
}

# Argo CD bootstrap
module "argocd" {
  source = "../../modules/argocd_bootstrap"

  cluster_name        = module.aks.cluster_name
  resource_group_name = module.spoke.resource_group_name
  repo_url            = var.gitops_repo_url
  repo_path_platform  = "argocd/applicationsets"
  argocd_domain       = "argocd.${var.dns_zone_name}"
  enable_aad_sso      = true
}
