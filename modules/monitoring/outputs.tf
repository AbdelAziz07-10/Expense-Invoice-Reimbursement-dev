output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_customer_id" {
  description = "Workspace (customer) ID, used by Container Apps environment logging."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "log_analytics_primary_shared_key" {
  description = "Primary shared key of the workspace (sensitive)."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "Resource ID of Application Insights."
  value       = azurerm_application_insights.this.id
}

output "application_insights_connection_string" {
  description = "Application Insights connection string (sensitive)."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}
