terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.7.0"        
    }
  }
}

variable "vnet-name" {
  type = string
  default = "app-vnet"
}

variable "address_space" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "other-vnet-id" {
  type = string
}

locals {
  subnet_address_space = [
    cidrsubnet(var.address_space[0], 2, 0)
  ]
}

resource "azurerm_virtual_network" "app_vnet" {
  name                = var.vnet-name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_virtual_network_peering" "vnet1-peering" {
  name = "vnet1-peering"
  resource_group_name       = var.resource_group_name
  remote_virtual_network_id = var.other-vnet-id
  virtual_network_name      = azurerm_virtual_network.app_vnet.name
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_subnet" "app-vnet-subnet" {
  name = "app-vnet-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes = local.subnet_address_space
}

resource "azurerm_subnet_network_security_group_association" "app-vnet-subnet-nsg" {
  subnet_id = azurerm_subnet.app-vnet-subnet.id
  network_security_group_id = var.nsg_id
}

output "app-vnet-id" {
  value = azurerm_virtual_network.app_vnet.id
}