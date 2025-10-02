resource "azurerm_private_dns_zone" "aks_api" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "storage_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "storage_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Link private DNS zones to hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "aks_api" {
  name                  = "link-aks-api-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks_api.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "link-acr-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "link-keyvault-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "link-storage-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_queue" {
  name                  = "link-storage-queue-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_queue.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_table" {
  name                  = "link-storage-table-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_table.name
  virtual_network_id    = var.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# Link private DNS zones to spoke VNet
resource "azurerm_private_dns_zone_virtual_network_link" "aks_api_spoke" {
  name                  = "link-aks-api-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks_api.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_spoke" {
  name                  = "link-acr-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_spoke" {
  name                  = "link-keyvault-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_spoke" {
  name                  = "link-storage-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_queue_spoke" {
  name                  = "link-storage-queue-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_queue.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_table_spoke" {
  name                  = "link-storage-table-spoke-${var.location_short}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_table.name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
