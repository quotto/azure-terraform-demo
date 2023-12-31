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
  backend "azurerm" {
    resource_group_name = "sandbox-rg"
    storage_account_name = "terraformstg9999"
    container_name = "state"
    use_oidc = true
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
    other_vnet_name = var.other_vnet_name
    remote_vnet_id = module.app-vnet.vnet_id
    remote_vnet_name = "${module.resource_group.name}-${module.app-vnet.vnet_name}"
}