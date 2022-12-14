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
  name                = "webapp-dso-${random_integer.ri.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"

    application_stack {
      dotnet_version = "6.0"
    }
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Development"
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.appdb.name};Persist Security Info=false;MultipleActiveResultSets=true;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Integrated Security=false;User Id=${azurerm_mssql_server.main.administrator_login};Password=${azurerm_mssql_server.main.administrator_login_password};"
  }

  virtual_network_subnet_id = azurerm_subnet.main.id
}

resource "azurerm_app_service_certificate" "domain" {
  name                = "${var.environment_name}-domain-cert"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  pfx_blob            = pkcs12_from_pem.domain_pfx.result
  password            = random_uuid.pfx_pass.result
}

resource "time_sleep" "wait_for_txt" {
  depends_on = [cloudflare_record.txt-verify]

  create_duration = "15s"
}

resource "azurerm_app_service_custom_hostname_binding" "domain" {
  hostname            = var.hostname
  app_service_name    = azurerm_linux_web_app.webapp.name
  resource_group_name = azurerm_resource_group.main.name

  depends_on = [
    time_sleep.wait_for_txt
  ]
}

resource "azurerm_app_service_certificate_binding" "example" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.domain.id
  certificate_id      = azurerm_app_service_certificate.domain.id
  ssl_state           = "SniEnabled"
}

data "dns_a_record_set" "app_ip_address" {
  host = azurerm_linux_web_app.webapp.default_hostname
}

output "app-ip" {
  value = data.dns_a_record_set.app_ip_address.addrs[0]
}

output "url" {
  value = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}

output "custom-url" {
  value = "https://${var.hostname}"
}
