variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "aks"
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "location_short" {
  description = "Short location name"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "vnet_subnet_id_system" {
  description = "ID of the system subnet"
  type        = string
}

variable "vnet_subnet_id_user" {
  description = "ID of the user subnet"
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone for AKS API"
  type        = string
}

variable "kubelet_uami_id" {
  description = "ID of the kubelet User-Assigned Managed Identity"
  type        = string
}

variable "workload_identity_enabled" {
  description = "Enable Workload Identity"
  type        = bool
  default     = true
}

variable "aad_rbac_enabled" {
  description = "Enable Azure AD RBAC"
  type        = bool
  default     = true
}

variable "network_plugin" {
  description = "Network plugin for AKS"
  type        = string
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "Network plugin mode for AKS"
  type        = string
  default     = "overlay"
}

variable "network_policy" {
  description = "Network policy for AKS"
  type        = string
  default     = "cilium"
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy"
  type        = bool
  default     = true
}

variable "service_cidr" {
  description = "Service CIDR for AKS"
  type        = string
  default     = "10.2.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
  default     = "10.2.0.10"
}

variable "pod_cidr" {
  description = "Pod CIDR for AKS (used with overlay mode)"
  type        = string
  default     = "10.244.0.0/16"
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}

variable "nodepools" {
  description = "Node pool configurations"
  type = object({
    system = object({
      vm_size = string
      min     = number
      max     = number
      zones   = list(string)
      taints  = list(string)
    })
    critical = object({
      vm_size = string
      min     = number
      max     = number
      zones   = list(string)
      taints  = list(string)
    })
    app = object({
      vm_size = string
      min     = number
      max     = number
      zones   = list(string)
    })
  })
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
