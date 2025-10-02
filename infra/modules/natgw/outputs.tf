output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.this.id
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = azurerm_nat_gateway.this.name
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = azurerm_public_ip.natgw.ip_address
}
