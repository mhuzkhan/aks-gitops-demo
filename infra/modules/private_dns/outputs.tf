output "aks_api_zone_id" {
  description = "ID of the AKS API private DNS zone"
  value       = azurerm_private_dns_zone.aks_api.id
}

output "acr_zone_id" {
  description = "ID of the ACR private DNS zone"
  value       = azurerm_private_dns_zone.acr.id
}

output "keyvault_zone_id" {
  description = "ID of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.id
}

output "storage_zone_id" {
  description = "ID of the Storage private DNS zone"
  value       = azurerm_private_dns_zone.storage.id
}

output "storage_queue_zone_id" {
  description = "ID of the Storage Queue private DNS zone"
  value       = azurerm_private_dns_zone.storage_queue.id
}

output "storage_table_zone_id" {
  description = "ID of the Storage Table private DNS zone"
  value       = azurerm_private_dns_zone.storage_table.id
}
