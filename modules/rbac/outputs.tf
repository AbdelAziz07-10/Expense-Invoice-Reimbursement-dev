output "assignments_created" {
  description = "Names of the role assignments created (empty when the module is disabled)."
  value       = keys(azurerm_role_assignment.this)
}
