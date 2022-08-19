
data "github_repository" "main" {
  full_name = "DevStarOps-org/Playing-with-Azure-and-Terraform"
}

resource "azuread_application_federated_identity_credential" "github" {
  application_object_id = azuread_application.main.object_id
  display_name          = "gh-${var.environment_name}-${random_integer.ri.result}-Playing-with-Azure-and-Terraform"
  description           = "Deployments for Playing-with-Azure-and-Terraform"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:DevStarOps-org/Playing-with-Azure-and-Terraform:environment:${var.environment_name}-app"
}
