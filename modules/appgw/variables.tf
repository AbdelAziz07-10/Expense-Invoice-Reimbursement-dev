variable "name_suffix" {
  description = "Suffix used in resource names, e.g. expense-dev."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the gateway resources."
  type        = string
}

variable "location" {
  description = "Azure region for the gateway."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "appgw_subnet_id" {
  description = "ID of the dedicated Application Gateway subnet."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace that receives gateway logs."
  type        = string
}

variable "brain_backend_ip" {
  description = "Internal static IP of the Container Apps environment (Brain backend)."
  type        = string
}

variable "brain_backend_fqdn" {
  description = "Ingress FQDN of the Brain app, sent as the Host header so the environment routes correctly."
  type        = string
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

variable "autoscale_min_capacity" {
  description = "Minimum Application Gateway capacity units."
  type        = number
  default     = 1
}

variable "autoscale_max_capacity" {
  description = "Maximum Application Gateway capacity units."
  type        = number
  default     = 2
}
