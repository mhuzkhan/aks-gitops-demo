variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "dns_zone_rg" {
  description = "Resource group containing the public DNS zone"
  type        = string
  default     = "rg-dns-prod"
}

variable "dns_zone_name" {
  description = "Public DNS zone name (e.g., example.com)"
  type        = string
  default     = "example.com"
}

variable "gitops_repo_url" {
  description = "GitOps repository URL"
  type        = string
  default     = "https://github.com/mhuzkhan/aks-gitops-demo"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "aks-zero-trust"
    ManagedBy   = "terraform"
  }
}
