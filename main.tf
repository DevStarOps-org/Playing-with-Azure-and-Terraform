terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.17.0"
    }
  }

  required_version = "= 1.2.4"

  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

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

output "shared_resource_group_name" {
  value = var.shared_resource_group_name
}

output "environment_name" {
  value = var.environment_name
}