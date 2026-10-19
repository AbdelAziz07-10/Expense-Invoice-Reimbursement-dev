output "resource_group_name" {
  description = "Name of the main resource group."
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet IDs (appgw, app, data)."
  value       = module.networking.subnet_ids
}

output "nat_gateway_public_ip" {
  description = "Outbound public IP of the NAT Gateway, or null when not created."
  value       = module.networking.nat_public_ip
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_name
}

output "application_insights_id" {
  description = "Resource ID of Application Insights."
  value       = module.monitoring.application_insights_id
}

output "private_dns_zone_ids" {
  description = "Private DNS zone IDs for the private endpoints."
  value       = module.private_dns.zone_ids
}

output "storage_account_name" {
  description = "Name of the storage account holding raw and clean files."
  value       = module.data.storage_account_name
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL server."
  value       = module.data.sql_server_fqdn
}

output "sql_admin_password" {
  description = "SQL administrator password (sensitive). Read it with: terraform output -raw sql_admin_password"
  value       = module.data.sql_admin_password
  sensitive   = true
}

output "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace."
  value       = module.data.servicebus_namespace_name
}

output "servicebus_queue_ids" {
  description = "Service Bus queue IDs by name."
  value       = module.data.servicebus_queue_ids
}

output "brain_fqdn" {
  description = "Internal FQDN of the Brain container app."
  value       = module.compute.brain_fqdn
}

output "container_app_environment_static_ip" {
  description = "Internal IP of the Container Apps environment (Application Gateway backend)."
  value       = module.compute.environment_static_ip
}

output "managed_identities" {
  description = "Managed identity IDs for Brain and OCR."
  value       = module.compute.identities
}

output "application_gateway_public_ip" {
  description = "Public IP of the Application Gateway."
  value       = module.appgw.public_ip_address
}

output "frontend_hostname" {
  description = "Default hostname of the frontend web app."
  value       = module.frontend.default_hostname
}

output "signalr_hostname" {
  description = "SignalR hostname."
  value       = module.messaging.signalr_hostname
}

output "function_app_name" {
  description = "Name of the notification Function App."
  value       = module.messaging.function_app_name
}

output "email_sender_domain" {
  description = "Azure-managed email sender domain."
  value       = module.messaging.email_sender_domain
}

output "function_identity" {
  description = "Managed identity of the Function App."
  value       = module.messaging.function_identity
}

output "eventgrid_system_topic_principal_id" {
  description = "Principal ID of the Event Grid system topic identity, or null when the topic is disabled."
  value       = module.messaging.eventgrid_system_topic_principal_id
}
