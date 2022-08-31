
# ARM_TENANT_ID
resource "github_actions_secret" "ARM_TENANT_ID" {
  repository       = data.github_repository.main.id
  secret_name      = "ARM_TENANT_ID"
  plaintext_value  = data.azurerm_client_config.current.tenant_id
}

# ARM_SUBSCRIPTION_ID
resource "github_actions_secret" "ARM_SUBSCRIPTION_ID" {
  repository       = data.github_repository.main.id
  secret_name      = "ARM_SUBSCRIPTION_ID"
  plaintext_value  = data.azurerm_client_config.current.subscription_id
}

# GITHUB_TOKEN
resource "github_actions_secret" "GITHUB_TOKEN" {
  repository       = data.github_repository.main.id
  secret_name      = "GH_TOKEN"
  plaintext_value  = var.github_token
}

# SNYK_TOKEN
resource "github_actions_secret" "SNYK_TOKEN" {
  repository       = data.github_repository.main.id
  secret_name      = "SNYK_TOKEN"
  plaintext_value  = var.snyk_token
}

# Cloudflare
resource "github_actions_secret" "CLOUDFLARE_SERVICE_KEY" {
  repository       = data.github_repository.main.id
  secret_name      = "CLOUDFLARE_SERVICE_KEY"
  plaintext_value  = var.cloudflare_service_key
}
resource "github_actions_secret" "CLOUDFLARE_ZONE_ID" {
  repository       = data.github_repository.main.id
  secret_name      = "CLOUDFLARE_ZONE_ID"
  plaintext_value  = var.cloudflare_zone_id
}
resource "github_actions_secret" "CLOUDFLARE_API_TOKEN" {
  repository       = data.github_repository.main.id
  secret_name      = "CLOUDFLARE_API_TOKEN"
  plaintext_value  = var.cloudflare_api_token
}
