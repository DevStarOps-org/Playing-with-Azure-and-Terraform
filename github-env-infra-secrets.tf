
# ARM_CLIENT_ID
resource "github_actions_environment_secret" "infra-ARM_CLIENT_ID" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.infra.environment
  secret_name      = "ARM_CLIENT_ID"
  plaintext_value  = azuread_application.main.application_id
}

# ARM_CLIENT_SECRET
resource "github_actions_environment_secret" "infra-ARM_CLIENT_SECRET" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.infra.environment
  secret_name      = "ARM_CLIENT_SECRET"
  plaintext_value  = azuread_service_principal_password.sp.value
}
