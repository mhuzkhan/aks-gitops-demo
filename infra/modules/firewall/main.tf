resource "azurerm_public_ip" "firewall" {
  name                = "pip-${var.name_prefix}-firewall-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "this" {
  name                = "afw-${var.name_prefix}-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  tags                = var.tags

  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  threat_intel_mode = "Alert"
}

# Network rule collection for AKS egress
resource "azurerm_firewall_network_rule_collection" "aks_egress" {
  name                = "aks-egress-rules"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "allow-aks-api"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["443", "22"]
    destination_addresses = ["AzureCloud"]
    protocols             = ["TCP"]
  }

  rule {
    name                  = "allow-aks-dns"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["53"]
    destination_addresses = ["168.63.129.16"]
    protocols             = ["UDP", "TCP"]
  }

  rule {
    name                  = "allow-aks-ntp"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["123"]
    destination_addresses = ["*"]
    protocols             = ["UDP"]
  }

  rule {
    name                  = "allow-aks-monitoring"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["443"]
    destination_addresses = ["AzureMonitor"]
    protocols             = ["TCP"]
  }
}

# Application rule collection for AKS egress
resource "azurerm_firewall_application_rule_collection" "aks_egress" {
  name                = "aks-egress-app-rules"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name             = "allow-aks-registry"
    source_addresses = var.aks_subnet_cidrs
    target_fqdns     = ["*.azurecr.io", "*.mcr.microsoft.com"]
  }

  rule {
    name             = "allow-aks-updates"
    source_addresses = var.aks_subnet_cidrs
    target_fqdns     = ["*.windowsupdate.com", "*.update.microsoft.com"]
  }

  rule {
    name             = "allow-aks-security"
    source_addresses = var.aks_subnet_cidrs
    target_fqdns     = ["*.securitycenter.azure.com"]
  }
}

# Network rule collection for private endpoints
resource "azurerm_firewall_network_rule_collection" "private_endpoints" {
  name                = "private-endpoints-rules"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name                  = "allow-keyvault"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["443"]
    destination_addresses = ["AzureKeyVault"]
    protocols             = ["TCP"]
  }

  rule {
    name                  = "allow-storage"
    source_addresses      = var.aks_subnet_cidrs
    destination_ports     = ["443"]
    destination_addresses = ["Storage"]
    protocols             = ["TCP"]
  }
}
