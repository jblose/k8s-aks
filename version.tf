terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = "~> 2.33.0"
  }

  # we provide backend on the CLI and configure via pipeline or env variables. This clears the warnings
  backend "azurerm" {
    resource_group_name  = "rgp-k8s-aks-kata"
    storage_account_name = "k8sakskata"
    container_name       = "tf-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
