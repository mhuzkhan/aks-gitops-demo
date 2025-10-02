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

variable "subnet_id" {
  description = "ID of the Azure Firewall subnet"
  type        = string
}

variable "aks_subnet_cidrs" {
  description = "CIDRs of AKS subnets for firewall rules"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
