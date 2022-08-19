data "azurerm_storage_account" "shared" {
  name                = "ugdemodso"
  resource_group_name = var.shared_resource_group_name
}
