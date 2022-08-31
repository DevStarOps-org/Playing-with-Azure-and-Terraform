terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.17.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    pkcs12 = {
      version = "0.0.7"
      source = "chilicat/pkcs12"
    }
  }

  required_version = "= 1.2.4"

  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_client_logging = false
  api_user_service_key = var.cloudflare_service_key
  api_token = var.cloudflare_api_token
}

provider "pkcs12" {}

data "azurerm_client_config" "current" {}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

provider "github" {
  token = var.github_token
  owner = "devstarops-org"
}

data "github_user" "current" {
  username = "devstarops"
}

variable "deploy_region" {
  type = string
  default = "westeurope"
}

variable "shared_resource_group_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "github_token" {
  type = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type = string
  sensitive = true
}

variable "cloudflare_service_key" {
  type = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}

output "shared_resource_group_name" {
  value = var.shared_resource_group_name
}

output "environment_name" {
  value = var.environment_name
}