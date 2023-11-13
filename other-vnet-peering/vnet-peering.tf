variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "other_vnet_name" {
  type = string
}
variable "remote_vnet_id" {
  type = string
}
variable "remote_vnet_name" {
  type = string
}
resource "azurerm_virtual_network_peering" "app-vnet-peering" {
  name = "${var.remote_vnet_name}-peering"
  resource_group_name       = var.resource_group_name
  remote_virtual_network_id = var.remote_vnet_id
  virtual_network_name      = var.other_vnet_name
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}