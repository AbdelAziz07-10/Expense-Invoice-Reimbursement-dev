output "public_ip_address" {
  description = "Public IP address of the Application Gateway (the single public entry point)."
  value       = azurerm_public_ip.appgw.ip_address
}

output "application_gateway_id" {
  description = "Resource ID of the Application Gateway."
  value       = azurerm_application_gateway.this.id
}

output "waf_policy_id" {
  description = "Resource ID of the WAF policy."
  value       = azurerm_web_application_firewall_policy.this.id
}
