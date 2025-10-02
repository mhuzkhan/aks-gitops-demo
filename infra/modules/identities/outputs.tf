output "kubelet_uami_id" {
  description = "ID of the kubelet User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.kubelet.id
}

output "kubelet_uami_client_id" {
  description = "Client ID of the kubelet User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

output "external_dns_uami_id" {
  description = "ID of the external-dns User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.external_dns.id
}

output "external_dns_client_id" {
  description = "Client ID of the external-dns User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.external_dns.client_id
}

output "external_secrets_uami_id" {
  description = "ID of the external-secrets User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.external_secrets.id
}

output "external_secrets_client_id" {
  description = "Client ID of the external-secrets User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.external_secrets.client_id
}

output "csi_keyvault_uami_id" {
  description = "ID of the CSI Key Vault User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.csi_keyvault.id
}

output "csi_keyvault_client_id" {
  description = "Client ID of the CSI Key Vault User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.csi_keyvault.client_id
}
