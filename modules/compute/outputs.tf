output "container_app_environment_id" {
  description = "ID of the Container Apps environment."
  value       = azurerm_container_app_environment.this.id
}

output "environment_default_domain" {
  description = "Default domain of the (internal) Container Apps environment."
  value       = azurerm_container_app_environment.this.default_domain
}

output "environment_static_ip" {
  description = "Internal static IP of the environment; used as the Application Gateway backend."
  value       = azurerm_container_app_environment.this.static_ip_address
}

output "brain_fqdn" {
  description = "Ingress FQDN of the Brain app."
  value       = azurerm_container_app.brain.ingress[0].fqdn
}

output "identities" {
  description = "Managed identity IDs, principal IDs and client IDs, used by the rbac module."
  value = {
    brain = {
      id           = azurerm_user_assigned_identity.brain.id
      principal_id = azurerm_user_assigned_identity.brain.principal_id
      client_id    = azurerm_user_assigned_identity.brain.client_id
    }
    ocr = {
      id           = azurerm_user_assigned_identity.ocr.id
      principal_id = azurerm_user_assigned_identity.ocr.principal_id
      client_id    = azurerm_user_assigned_identity.ocr.client_id
    }
  }
}
