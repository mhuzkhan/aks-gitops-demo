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

variable "spoke_address_space" {
  description = "Address space for spoke VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "hub_vnet_id" {
  description = "ID of the hub VNet"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Name of the hub resource group"
  type        = string
}

variable "firewall_private_ip" {
  description = "Private IP of the Azure Firewall"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "aks_system_subnet_cidrs" {
  description = "CIDRs for AKS system subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "aks_user_subnet_cidrs" {
  description = "CIDRs for AKS user subnets"
  type        = list(string)
  default     = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
