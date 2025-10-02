resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name_prefix}-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.name_prefix}-${var.location_short}"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  # Private cluster configuration
  private_cluster_enabled = true
  private_dns_zone_id     = var.private_dns_zone_id

  # Network configuration
  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    pod_cidr            = var.pod_cidr
  }

  # Identity configuration
  identity {
    type         = "UserAssigned"
    identity_ids = [var.kubelet_uami_id]
  }

  # OIDC and Workload Identity
  oidc_issuer_enabled       = var.workload_identity_enabled
  workload_identity_enabled = var.workload_identity_enabled

  # Azure AD RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
  }

  # Default node pool (system)
  default_node_pool {
    name           = "system"
    vm_size        = var.nodepools.system.vm_size
    node_count     = var.nodepools.system.min
    min_count      = var.nodepools.system.min
    max_count      = var.nodepools.system.max
    vnet_subnet_id = var.vnet_subnet_id_system

    node_labels = {
      "nodepool" = "system"
    }
  }

  # Azure Policy
  azure_policy_enabled = var.enable_azure_policy

  # Auto-scaler profile
  auto_scaler_profile {
    balance_similar_node_groups      = true
    expander                         = "priority"
    max_graceful_termination_sec     = 600
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_utilization_threshold = "0.5"
    skip_nodes_with_local_storage    = false
    skip_nodes_with_system_pods      = true
  }

  # Maintenance window
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [2, 3, 4, 5]
    }
  }

  # Monitoring
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # Security features
  role_based_access_control_enabled = true
  sku_tier                          = "Standard"

  # Defender for Cloud - configured via Azure Policy
}

# Additional node pools
resource "azurerm_kubernetes_cluster_node_pool" "critical" {
  name                  = "critical"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.nodepools.critical.vm_size
  node_count            = var.nodepools.critical.min
  min_count             = var.nodepools.critical.min
  max_count             = var.nodepools.critical.max
  vnet_subnet_id        = var.vnet_subnet_id_user
  auto_scaling_enabled  = true

  # Taints for critical workloads
  node_taints = var.nodepools.critical.taints

  # Labels
  node_labels = {
    "nodepool" = "critical"
  }

  # OS configuration
  os_sku  = "Ubuntu"
  os_type = "Linux"
}

resource "azurerm_kubernetes_cluster_node_pool" "app" {
  name                  = "app"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.nodepools.app.vm_size
  node_count            = var.nodepools.app.min
  min_count             = var.nodepools.app.min
  max_count             = var.nodepools.app.max
  vnet_subnet_id        = var.vnet_subnet_id_user
  auto_scaling_enabled  = true

  # Labels
  node_labels = {
    "nodepool" = "app"
  }

  # OS configuration
  os_sku  = "Ubuntu"
  os_type = "Linux"
}

# Data source for kubeconfig
data "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_kubernetes_cluster.this.name
  resource_group_name = azurerm_kubernetes_cluster.this.resource_group_name
  depends_on          = [azurerm_kubernetes_cluster.this]
}
