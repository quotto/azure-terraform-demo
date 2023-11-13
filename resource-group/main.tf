variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "policy_definition_id" {
  type = string
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_management_lock" "resource_group_level_lock" {
  name       = "${azurerm_resource_group.resource_group.name}-group-lock"
  scope      = azurerm_resource_group.resource_group.id
  lock_level = "CanNotDelete"
}

resource "azurerm_resource_group_policy_assignment" "policy_assignment" {
  name = "${azurerm_resource_group.resource_group.name}-policy-assignment"
  location = var.location
  resource_group_id = azurerm_resource_group.resource_group.id
  policy_definition_id = var.policy_definition_id
  identity {
    type = "SystemAssigned"
  }
}

output "name" {
  value = azurerm_resource_group.resource_group.name
}