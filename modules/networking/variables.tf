variable "name_suffix" {
  description = "Suffix used in resource names."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for networking resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Tags applied to all networking resources."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space of the virtual network as a list of IPv4 CIDR blocks."
  type        = list(string)

  validation {
    condition     = length(var.vnet_address_space) > 0 && alltrue([for c in var.vnet_address_space : can(cidrnetmask(c))])
    error_message = "vnet_address_space must contain at least one valid IPv4 CIDR block, for example 10.10.0.0/16."
  }
}

variable "appgw_subnet_cidr" {
  description = "IPv4 CIDR of the Application Gateway subnet."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.appgw_subnet_cidr))
    error_message = "appgw_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "app_subnet_cidr" {
  description = "IPv4 CIDR of the application subnet. Container Apps requires a /23 or larger range."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.app_subnet_cidr)) && tonumber(split("/", var.app_subnet_cidr)[1]) <= 23
    error_message = "app_subnet_cidr must be a valid IPv4 CIDR block with a prefix of /23 or larger."
  }
}

variable "data_subnet_cidr" {
  description = "IPv4 CIDR of the data subnet that hosts the private endpoints."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.data_subnet_cidr))
    error_message = "data_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Create and attach the NAT Gateway."
  type        = bool
  default     = true
}

variable "create_nat_public_ip" {
  description = "Create and associate a public IP with the NAT Gateway."
  type        = bool
  default     = false
}
