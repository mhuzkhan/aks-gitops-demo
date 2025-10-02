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

variable "hub_vnet_id" {
  description = "ID of the hub VNet"
  type        = string
}

variable "spoke_vnet_id" {
  description = "ID of the spoke VNet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
