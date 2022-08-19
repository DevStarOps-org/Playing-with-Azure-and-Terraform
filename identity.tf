
resource "azuread_application" "main" {
  display_name = "demo-${var.environment_name}-${random_integer.ri.result}"
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "azurerm_role_assignment" "shared-storage-owner" {
  scope                = data.azurerm_storage_account.shared.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.main.object_id
}

resource "azurerm_role_assignment" "rg-owner" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.main.object_id
}

resource "azurerm_user_assigned_identity" "app" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  name = "${var.environment_name}-app-user-${random_integer.ri.result}"
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.main.id
  end_date_relative    = "2400h30m"
}

output "azure_app" {
  value = azuread_application.main.display_name
}

output "client_id" {
  value = azuread_application.main.application_id
}
