output "web_app_id" {
  description = "Resource ID of the frontend web app."
  value       = azurerm_linux_web_app.frontend.id
}

output "web_app_name" {
  description = "Name of the frontend web app."
  value       = azurerm_linux_web_app.frontend.name
}

output "default_hostname" {
  description = "Default hostname (the Application Gateway backend, when you connect it)."
  value       = azurerm_linux_web_app.frontend.default_hostname
}
