variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "ingress_nginx" {
  description = "Configuration for Ingress NGINX"
  type = object({
    internal    = bool
    annotations = map(string)
  })
  default = {
    internal    = true
    annotations = {}
  }
}

variable "cert_manager" {
  description = "Configuration for cert-manager"
  type = object({
    email = string
  })
}

variable "external_dns" {
  description = "Configuration for external-dns"
  type = object({
    dns_zone_rg    = string
    dns_zone_name  = string
    uami_client_id = string
  })
}

variable "external_secrets" {
  description = "Configuration for external-secrets"
  type = object({
    keyvault_id    = string
    uami_client_id = string
  })
}

variable "csi_keyvault" {
  description = "Configuration for CSI Key Vault"
  type = object({
    uami_client_id = string
  })
}
