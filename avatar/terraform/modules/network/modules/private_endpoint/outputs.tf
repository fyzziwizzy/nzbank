output "id" {
  description = "Resource id of the private endpoint."
  value       = azurerm_private_endpoint.this.id
}

output "name" {
  description = "Name of the private endpoint."
  value       = azurerm_private_endpoint.this.name
}

output "private_ip_address" {
  description = "Private IP address assigned to the endpoint NIC."
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "network_interface_id" {
  description = "Resource id of the endpoint network interface."
  value       = azurerm_private_endpoint.this.network_interface[0].id
}
