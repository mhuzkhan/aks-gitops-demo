output "argocd_version" {
  description = "Version of Argo CD"
  value       = helm_release.argocd.version
}

output "argocd_server_url" {
  description = "URL of the Argo CD server"
  value       = "https://${var.argocd_domain}"
}
