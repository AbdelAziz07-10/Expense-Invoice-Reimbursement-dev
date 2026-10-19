variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "environment" {
  description = "Environment name (used in the function storage account name)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the messaging resources."
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

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace that receives diagnostic logs."
  type        = string
}

variable "app_insights_connection_string" {
  description = "Application Insights connection string for the Function App."
  type        = string
  sensitive   = true
}

variable "storage_account_id" {
  description = "ID of the uploads storage account (Event Grid system topic source)."
  type        = string
}

variable "raw_container_name" {
  description = "Name of the raw uploads container, used to filter Event Grid events."
  type        = string
}

variable "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace."
  type        = string
}

variable "scan_results_queue_id" {
  description = "ID of the Service Bus queue that receives scan events."
  type        = string
}

variable "notifications_queue_name" {
  description = "Name of the Service Bus queue that triggers the notification Function."
  type        = string
  default     = "notifications"
}

variable "signalr_sku_name" {
  description = "SignalR SKU name (Free_F1 or Standard_S1)."
  type        = string
  default     = "Free_F1"
}

variable "signalr_capacity" {
  description = "SignalR unit count (must be 1 for Free_F1)."
  type        = number
  default     = 1
}

variable "email_data_location" {
  description = "Data location for Communication Services (for example Europe, United States)."
  type        = string
  default     = "Europe"
}

variable "function_plan_sku" {
  description = "App Service plan SKU for the Function App (Y1 = consumption)."
  type        = string
  default     = "Y1"
}

variable "enable_eventgrid_topic" {
  description = "Create the event grid system topic on the uploads storage account"
  type = bool
  default = true
}

variable "enable_eventgrid_subscription" {
  description = "Create the subscription that deliver to the scan-results queue"
  type = bool
  default = false
}

variable "eventgrid_event_types" {
  description = "Event types forwarded to the queue."
  type        = list(string)
  default     = ["Microsoft.Storage.BlobCreated"]
}
