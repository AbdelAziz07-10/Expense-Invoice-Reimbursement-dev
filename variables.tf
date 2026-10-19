variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "project" {
  description = "Short project name used in resource names."
  type        = string
  default     = "expense"

  validation {
    condition     = can(regex("^[a-z0-9]{2,12}$", var.project))
    error_message = "project must be 2-12 lowercase letters or digits because it is part of globally unique storage account names."
  }
}

variable "environment" {
  description = "Environment name: dev, test or prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space of the virtual network as a list of IPv4 CIDR blocks."
  type        = list(string)

  validation {
    condition     = length(var.vnet_address_space) > 0 && alltrue([for c in var.vnet_address_space : can(cidrnetmask(c))])
    error_message = "vnet_address_space must contain at least one valid IPv4 CIDR block."
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

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

variable "enable_private_endpoints" {
  description = "Create private endpoints for SQL and Blob Storage."
  type        = bool
  default     = true
}

variable "enable_servicebus_private_endpoint" {
  description = "Create a Service Bus private endpoint. Requires servicebus_sku = Premium."
  type        = bool
  default     = false
}

variable "servicebus_sku" {
  description = "Service Bus SKU: Basic, Standard or Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.servicebus_sku)
    error_message = "servicebus_sku must be Basic, Standard or Premium."
  }
}

variable "storage_public_network_access_enabled" {
  description = "Allow public network access to the uploads storage account."
  type        = bool
  default     = true
}

variable "sql_admin_login" {
  description = "SQL administrator login name."
  type        = string
  default     = "sqladmin_expense"
}

variable "sql_admin_password" {
  description = "SQL administrator password. Leave unset to auto-generate one. If set, pass it with TF_VAR_sql_admin_password."
  type        = string
  default     = null
  sensitive   = true
}

variable "sql_database_sku" {
  description = "SQL database SKU."
  type        = string
  default     = "Basic"
}

variable "container_image" {
  description = "Placeholder container image used by Brain and OCR until real images exist."
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart:latest"
}

variable "waf_mode" {
  description = "WAF mode: Detection or Prevention."
  type        = string
  default     = "Prevention"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "waf_mode must be Detection or Prevention."
  }
}

variable "app_service_plan_sku" {
  description = "App Service plan SKU for the frontend."
  type        = string
  default     = "B1"
}

variable "frontend_site_config" {
  description = "Site settings of the frontend web app."
  type = object({
    always_on           = optional(bool, true)
    minimum_tls_version = optional(string, "1.2")
    ftps_state          = optional(string, "Disabled")
    http2_enabled       = optional(bool, true)
  })
  default = {}
}

variable "signalr_sku_name" {
  description = "SignalR SKU: Free_F1 or Standard_S1."
  type        = string
  default     = "Free_F1"
}

variable "email_data_location" {
  description = "Data location for Communication Services email."
  type        = string
  default     = "Europe"
}

variable "function_plan_sku" {
  description = "App Service plan SKU for the Function App. Y1 is the consumption plan."
  type        = string
  default     = "Y1"
}

variable "enable_eventgrid_topic" {
  description = "Create the Event Grid system topic on the uploads storage account."
  type        = bool
  default     = true
}

variable "enable_eventgrid_subscription" {
  description = "Create the Event Grid subscription to the scan-results queue. Requires the Service Bus Data Sender role on the topic identity."
  type        = bool
  default     = false
}
