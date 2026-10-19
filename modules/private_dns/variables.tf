variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the private DNS zones in."
  type        = string
}

variable "vnet_id" {
  description = "ID of the VNet the zones are linked to."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "Map of logical name to private DNS zone name, one per private endpoint type."
  type        = map(string)
  default = {
    sql        = "privatelink.database.windows.net"
    blob       = "privatelink.blob.core.windows.net"
    servicebus = "privatelink.servicebus.windows.net"
  }
}
