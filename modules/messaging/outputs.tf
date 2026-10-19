output "signalr_id" {
  description = "Resource ID of the SignalR service."
  value       = azurerm_signalr_service.this.id
}

output "signalr_hostname" {
  description = "Hostname of the SignalR service."
  value       = azurerm_signalr_service.this.hostname
}

output "communication_service_id" {
  description = "Resource ID of the Communication Service."
  value       = azurerm_communication_service.this.id
}

output "email_sender_domain" {
  description = "Azure-managed sender domain for outgoing email."
  value       = azurerm_email_communication_service_domain.managed.mail_from_sender_domain
}

output "function_app_id" {
  description = "Resource ID of the Function App."
  value       = azurerm_linux_function_app.this.id
}

output "function_app_name" {
  description = "Name of the Function App."
  value       = azurerm_linux_function_app.this.name
}

output "function_identity" {
  description = "Managed identity of the Function App (used by the rbac module)."
  value = {
    id           = azurerm_user_assigned_identity.function.id
    principal_id = azurerm_user_assigned_identity.function.principal_id
    client_id    = azurerm_user_assigned_identity.function.client_id
  }
}

output "eventgrid_system_topic_principal_id" {
  description = "Principal ID of the Event Grid system topic identity (null when disabled)."
  value       = var.enable_eventgrid_topic ? azurerm_eventgrid_system_topic.storage[0].identity[0].principal_id : null
}
