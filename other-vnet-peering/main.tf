variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "other-vnet-name" {
  type = string
}
variable "app-vnet-id" {
  type = string
}
resource "azurerm_virtual_network_peering" "app-vnet-peering" {
  name = "app-vnet-peering"
  resource_group_name       = var.resource_group_name
  remote_virtual_network_id = var.app-vnet-id
  virtual_network_name      = var.other-vnet-name
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}