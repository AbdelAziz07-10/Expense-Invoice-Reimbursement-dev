output "zone_ids" {
  description = "Map of logical name (sql, blob, servicebus) to private DNS zone ID."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.id }
}

output "zone_names" {
  description = "Map of logical name to private DNS zone name."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.name }
}
