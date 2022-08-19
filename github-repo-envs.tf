
resource "github_repository_environment" "infra" {
  environment  = "${var.environment_name}-infra"
  repository   = data.github_repository.main.id
  reviewers {
    users = var.environment_name == "production" ? [data.github_user.current.id] : null
  }  
}

resource "github_repository_environment" "app" {
  environment  = "${var.environment_name}-app"
  repository   = data.github_repository.main.id
  reviewers {
    users = var.environment_name == "production" ? [data.github_user.current.id] : null
  }  
}
