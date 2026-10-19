output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "storage_container_names" {
  description = "Names of the raw and clean containers."
  value = {
    raw   = azurerm_storage_container.raw.name
    clean = azurerm_storage_container.clean.name
  }
}

output "sql_server_id" {
  description = "Resource ID of the SQL server."
  value       = azurerm_mssql_server.this.id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Name of the SQL database."
  value       = azurerm_mssql_database.this.name
}

output "sql_admin_password" {
  description = "SQL administrator password (sensitive). Read with: terraform output -raw sql_admin_password"
  value       = local.sql_admin_password
  sensitive   = true
}

output "servicebus_namespace_id" {
  description = "Resource ID of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.name
}

output "servicebus_queue_ids" {
  description = "Map of queue name to queue ID."
  value       = { for k, q in azurerm_servicebus_queue.this : k => q.id }
}
