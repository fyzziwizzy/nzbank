output "resource_group_name" {
  description = "Name of the platform resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Resource id of the platform resource group."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Azure region the platform is deployed into."
  value       = azurerm_resource_group.this.location
}

output "vnet_id" {
  description = "Resource id of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet key to subnet resource id."
  value = {
    edge        = azurerm_subnet.edge.id
    runtime     = azurerm_subnet.runtime.id
    privatelink = azurerm_subnet.privatelink.id
    apim        = azurerm_subnet.apim.id
    firewall    = azurerm_subnet.firewall.id
    bastion     = azurerm_subnet.bastion.id
  }
}

output "private_endpoint_subnet_id" {
  description = "Resource id of the subnet used for private endpoints."
  value       = azurerm_subnet.privatelink.id
}

output "runtime_subnet_id" {
  description = "Resource id of the Container Apps runtime subnet."
  value       = azurerm_subnet.runtime.id
}

output "apim_subnet_id" {
  description = "Resource id of the API Management subnet."
  value       = azurerm_subnet.apim.id
}

output "private_dns_zone_ids" {
  description = "Map of service key to private DNS zone resource id."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.id }
}

output "private_dns_zone_names" {
  description = "Map of service key to private DNS zone name."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.name }
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall, used as the egress next hop."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "firewall_id" {
  description = "Resource id of the Azure Firewall."
  value       = azurerm_firewall.this.id
}
