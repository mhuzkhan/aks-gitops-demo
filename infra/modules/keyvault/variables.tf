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

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access Key Vault"
  type        = list(string)
}

variable "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  type        = string
}

variable "keyvault_private_dns_zone_id" {
  description = "ID of the Key Vault private DNS zone"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
