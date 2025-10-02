resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name_prefix}-hub-${var.location_short}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name_prefix}-hub-${var.location_short}"
  address_space       = var.hub_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.firewall_subnet_cidr
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.bastion_subnet_cidr
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-${var.name_prefix}-private-endpoints"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_endpoints_subnet_cidr
}
