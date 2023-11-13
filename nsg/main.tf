variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
resource "azurerm_network_security_group" "network_security_group" {
    name = "app-nsg"
    location = var.location
    resource_group_name = var.resource_group_name
}

output "nsg_id" {
  value = azurerm_network_security_group.network_security_group.id
}