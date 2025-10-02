resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name_prefix}-spoke-${var.location_short}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name_prefix}-spoke-${var.location_short}"
  address_space       = var.spoke_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# Peering from spoke to hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Peering from hub to spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

# AKS System subnet
resource "azurerm_subnet" "aks_system" {
  count                = length(var.availability_zones)
  name                 = "snet-${var.name_prefix}-aks-system-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_system_subnet_cidrs[count.index]]

  service_endpoints = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault"]
}

# AKS User subnet
resource "azurerm_subnet" "aks_user" {
  count                = length(var.availability_zones)
  name                 = "snet-${var.name_prefix}-aks-user-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_user_subnet_cidrs[count.index]]

  service_endpoints = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault"]
}

# Route table for AKS subnets
resource "azurerm_route_table" "aks" {
  name                = "rt-${var.name_prefix}-aks-${var.location_short}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# Route to Azure Firewall for egress
resource "azurerm_route" "firewall" {
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.aks.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

# Associate route table with AKS subnets
resource "azurerm_subnet_route_table_association" "aks_system" {
  count          = length(azurerm_subnet.aks_system)
  subnet_id      = azurerm_subnet.aks_system[count.index].id
  route_table_id = azurerm_route_table.aks.id
}

resource "azurerm_subnet_route_table_association" "aks_user" {
  count          = length(azurerm_subnet.aks_user)
  subnet_id      = azurerm_subnet.aks_user[count.index].id
  route_table_id = azurerm_route_table.aks.id
}
