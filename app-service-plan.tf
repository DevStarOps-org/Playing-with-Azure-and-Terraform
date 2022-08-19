# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-dso-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B3"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-dso-${random_integer.ri.result}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    
    application_stack   {
      dotnet_version = "6.0"
    }
  }
  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.app.id ]
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Development"
  }

  connection_string {
    name = "DefaultConnection"
    type = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.appdb.name};Persist Security Info=false;MultipleActiveResultSets=true;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Integrated Security=false;User Id=${azurerm_mssql_server.main.administrator_login};Password=${azurerm_mssql_server.main.administrator_login_password};"
  }

  virtual_network_subnet_id = azurerm_subnet.main.id
}

output "url" {
  value = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}
