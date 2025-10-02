resource "azurerm_public_ip" "natgw" {
  name                = "pip-${var.name_prefix}-natgw-${var.location_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  name                    = "natgw-${var.name_prefix}-${var.location_short}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.natgw.id
}

# Associate NAT Gateway with AKS subnets
resource "azurerm_subnet_nat_gateway_association" "aks_system" {
  count          = length(var.aks_system_subnet_ids)
  subnet_id      = var.aks_system_subnet_ids[count.index]
  nat_gateway_id = azurerm_nat_gateway.this.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_user" {
  count          = length(var.aks_user_subnet_ids)
  subnet_id      = var.aks_user_subnet_ids[count.index]
  nat_gateway_id = azurerm_nat_gateway.this.id
}
