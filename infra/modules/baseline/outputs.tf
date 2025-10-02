output "metrics_server_version" {
  description = "Version of metrics-server"
  value       = helm_release.metrics_server.version
}

output "ingress_nginx_version" {
  description = "Version of ingress-nginx"
  value       = helm_release.ingress_nginx.version
}

output "cert_manager_version" {
  description = "Version of cert-manager"
  value       = helm_release.cert_manager.version
}

output "external_secrets_version" {
  description = "Version of external-secrets"
  value       = helm_release.external_secrets.version
}

output "external_dns_version" {
  description = "Version of external-dns"
  value       = helm_release.external_dns.version
}
