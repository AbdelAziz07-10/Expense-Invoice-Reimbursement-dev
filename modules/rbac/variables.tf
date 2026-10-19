variable "enable_role_assignments" {
  description = "Create the role assignments. Needs Owner or User Access Administrator on the scopes. Off by default."
  type        = bool
  default     = false
}

variable "identities" {
  description = "Principal IDs of the managed identities. Keys: brain, ocr, function."
  type = map(object({
    id           = string
    principal_id = string
    client_id    = string
  }))
}

variable "storage_account_id" {
  description = "Scope: uploads storage account."
  type        = string
}

variable "servicebus_namespace_id" {
  description = "Scope: Service Bus namespace."
  type        = string
}

variable "signalr_id" {
  description = "Scope: SignalR service."
  type        = string
}

variable "enable_eventgrid_assignment" {
  description = "Also grant the Event Grid system topic identity permission to send to Service Bus."
  type        = bool
  default     = true
}

variable "eventgrid_principal_id" {
  description = "Principal ID of the Event Grid system topic identity (null when the subscription is disabled)."
  type        = string
  default     = null
}
