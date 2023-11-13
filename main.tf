variable "location" {
    type = string
    default = "japaneast"
}
variable "resource_group_name" {
    type = string
}

variable "policy_definition_id" {
    type = string
}

variable "address_space" {
    type = list(string)
}

variable "other_vnet_resource_group_name" {
    type = string
}

variable "other_vnet_id" {
    type = string
}

variable "other_vnet_name" {
    type = string
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }
}

provider "azurerm" {
    use_oidc = true
    features {}
}

module "resource_group" {
    source = "./resource-group"
    location = var.location
    resource_group_name = var.resource_group_name
    policy_definition_id = var.policy_definition_id
}

module "app-vnet" {
    source = "./vnet"
    location = var.location
    resource_group_name = module.resource_group.name
    address_space = var.address_space
    nsg_id = module.nsg.nsg_id
    other-vnet-id = var.other_vnet_id
}

module "nsg" {
    source = "./nsg"
    location = var.location
    resource_group_name = module.resource_group.name
}

module "other-vnet-peering" {
    source = "./other-vnet-peering"
    location = var.location
    resource_group_name = var.other_vnet_resource_group_name
    other-vnet-name = var.other_vnet_name
    app-vnet-id = module.app-vnet.app-vnet-id
}