output "resource_group_name" {
  description = "Name of the hub resource group"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the hub VNet"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the hub VNet"
  value       = azurerm_virtual_network.this.name
}

output "firewall_subnet_id" {
  description = "ID of the Azure Firewall subnet"
  value       = azurerm_subnet.firewall.id
}

output "bastion_subnet_id" {
  description = "ID of the Azure Bastion subnet"
  value       = azurerm_subnet.bastion.id
}

output "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}
