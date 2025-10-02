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

variable "hub_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "firewall_subnet_cidr" {
  description = "CIDR for Azure Firewall subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "bastion_subnet_cidr" {
  description = "CIDR for Azure Bastion subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "private_endpoints_subnet_cidr" {
  description = "CIDR for private endpoints subnet"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
