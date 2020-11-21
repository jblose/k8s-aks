terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = "~> 2.33.0"
  }

  # we provide backend on the CLI and configure via pipeline or env variables. This clears the warnings
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
