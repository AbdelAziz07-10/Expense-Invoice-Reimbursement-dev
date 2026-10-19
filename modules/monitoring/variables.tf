variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create monitoring resources in."
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

variable "retention_in_days" {
  description = "Log Analytics data retention in days (30-730)."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "retention_in_days must be between 30 and 730."
  }
}

variable "log_analytics_sku" {
  description = "Log Analytics workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "application_insights_type" {
  description = "Application Insights application type."
  type        = string
  default     = "web"
}
