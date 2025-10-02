variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "repo_url" {
  description = "GitOps repository URL"
  type        = string
}

variable "repo_path_platform" {
  description = "Path to platform applications in the GitOps repository"
  type        = string
  default     = "argocd/applicationsets"
}

variable "argocd_domain" {
  description = "Domain for Argo CD"
  type        = string
  default     = "argocd.example.com"
}

variable "enable_aad_sso" {
  description = "Enable Azure AD SSO for Argo CD"
  type        = bool
  default     = false
}
