output "vnet_id" {
  description = "ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Subnet IDs by tier."
  value = {
    appgw = azurerm_subnet.appgw.id
    app   = azurerm_subnet.app.id
    data  = azurerm_subnet.data.id
  }
}

output "nat_public_ip" {
  description = "NAT Public IP, or null when not created."
  value = (
    var.enable_nat_gateway &&
    var.create_nat_public_ip
  ) ? azurerm_public_ip.nat[0].ip_address : null
}
