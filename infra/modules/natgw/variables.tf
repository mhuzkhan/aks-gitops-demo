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

variable "aks_system_subnet_ids" {
  description = "List of AKS system subnet IDs"
  type        = list(string)
}

variable "aks_user_subnet_ids" {
  description = "List of AKS user subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
