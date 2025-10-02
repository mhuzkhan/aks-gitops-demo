output "resource_group_name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the spoke VNet"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the spoke VNet"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    aks-system = { for i, subnet in azurerm_subnet.aks_system : "zone-${i + 1}" => subnet.id }
    aks-user   = { for i, subnet in azurerm_subnet.aks_user : "zone-${i + 1}" => subnet.id }
  }
}

output "aks_system_subnet_ids" {
  description = "List of AKS system subnet IDs"
  value       = azurerm_subnet.aks_system[*].id
}

output "aks_user_subnet_ids" {
  description = "List of AKS user subnet IDs"
  value       = azurerm_subnet.aks_user[*].id
}
