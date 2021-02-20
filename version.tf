terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = ">= 2.48.0"
  }

  # we provide backend on the CLI and configure via pipeline or env variables. This clears the warnings
  backend "azurerm" {
    resource_group_name  = "iac-jblose-rgp"
    storage_account_name = "iacjblose"
    container_name       = "tf-state"
    key                  = "k8s-kata-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
