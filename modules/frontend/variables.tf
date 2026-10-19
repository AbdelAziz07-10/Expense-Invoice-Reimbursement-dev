variable "name_suffix" {
  description = "Suffix used in resource names. Maximum 47 characters so the web app name stays within the 60-character Azure limit."
  type        = string

  validation {
    condition     = length(var.name_suffix) <= 47 && can(regex("^[a-z0-9-]+$", var.name_suffix))
    error_message = "name_suffix must be at most 47 characters and contain only lowercase letters, digits and hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group for the frontend resources."
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
  description = "Application Insights connection string for the frontend."
  type        = string
  sensitive   = true
}

variable "app_service_plan_sku" {
  description = "App Service plan SKU, for example B1, S1 or P0v3."
  type        = string
  default     = "B1"
}

variable "node_version" {
  description = "Node.js runtime version for the frontend."
  type        = string
  default     = "20-lts"
}

variable "site_config" {
  description = "Web app site settings. Override them to match the application requirements."
  type = object({
    always_on           = optional(bool, true)
    minimum_tls_version = optional(string, "1.2")
    ftps_state          = optional(string, "Disabled")
    http2_enabled       = optional(bool, true)
  })
  default = {}

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.site_config.minimum_tls_version)
    error_message = "site_config.minimum_tls_version must be 1.0, 1.1, 1.2 or 1.3."
  }

  validation {
    condition     = contains(["AllAllowed", "FtpsOnly", "Disabled"], var.site_config.ftps_state)
    error_message = "site_config.ftps_state must be AllAllowed, FtpsOnly or Disabled."
  }
}
