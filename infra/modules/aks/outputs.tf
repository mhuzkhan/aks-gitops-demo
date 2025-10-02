output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "cluster_identity" {
  description = "Identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.identity
}

output "kube_config" {
  description = "Kube config for the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "cluster_resource_group_name" {
  description = "Name of the AKS cluster resource group"
  value       = azurerm_kubernetes_cluster.this.resource_group_name
}
