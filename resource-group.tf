
resource "azurerm_resource_group" "main" {
  name     = "ugdemo-${var.environment_name}-rg"
  location = var.deploy_region
}

output "main_resource_group" {
  value = azurerm_resource_group.main.name
}
