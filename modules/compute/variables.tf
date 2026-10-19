variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the compute resources."
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

variable "app_subnet_id" {
  description = "ID of the application subnet (delegated to Microsoft.App/environments)."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace that receives Container Apps logs."
  type        = string
}

variable "app_insights_connection_string" {
  description = "Application Insights connection string, passed to the apps as a secret."
  type        = string
  sensitive   = true
}

variable "sql_server_fqdn" {
  description = "FQDN of the SQL server."
  type        = string
}

variable "sql_database_name" {
  description = "Name of the SQL database."
  type        = string
}

variable "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace."
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account."
  type        = string
}

variable "container_image" {
  description = "Placeholder image for Brain and OCR. Replace with the real images when application code exists."
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart:latest"
}

variable "min_replicas" {
  description = "Minimum replicas per container app."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum replicas per container app."
  type        = number
  default     = 3
}
