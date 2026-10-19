variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "project" {
  description = "Short project name (used in the globally unique storage account name)."
  type        = string
}

variable "environment" {
  description = "Environment name (used in the storage account name)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the data resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "data_subnet_id" {
  description = "ID of the data subnet that hosts the private endpoints."
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs with keys sql, blob, servicebus."
  type        = map(string)
}

variable "enable_private_endpoints" {
  description = "Create private endpoints for SQL and Blob Storage."
  type        = bool
  default     = true
}

variable "enable_servicebus_private_endpoint" {
  description = "Create a private endpoint for Service Bus. Requires servicebus_sku = Premium (expensive)."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace that receives diagnostic logs."
  type        = string
}

variable "storage_replication_type" {
  description = "Storage replication type (LRS, ZRS, GRS...)."
  type        = string
  default     = "LRS"
}

variable "storage_public_network_access_enabled" {
  description = "Allow public network access to the storage account. Set to false once private endpoints are in use."
  type        = bool
  default     = true
}

variable "sql_admin_login" {
  description = "SQL server administrator login name."
  type        = string
  default     = "sqladmin_expense"
}

variable "sql_admin_password" {
  description = "SQL administrator password. Leave null to generate a random one (kept only in remote state). Supply via TF_VAR_sql_admin_password, never in a tfvars file."
  type        = string
  default     = null
  sensitive   = true
}

variable "sql_database_sku" {
  description = "SQL database SKU (Basic, S0, GP_S_Gen5_1...)."
  type        = string
  default     = "Basic"
}

variable "sql_max_size_gb" {
  description = "Maximum SQL database size in GB."
  type        = number
  default     = 2
}

variable "servicebus_sku" {
  description = "Service Bus SKU: Basic, Standard or Premium. Private endpoints need Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.servicebus_sku)
    error_message = "servicebus_sku must be Basic, Standard or Premium."
  }
}

variable "servicebus_queues" {
  description = "Queues to create in the Service Bus namespace."
  type        = set(string)
  default     = ["scan-results", "ocr-completed", "notifications"]
}
