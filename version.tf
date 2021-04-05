terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = "~> 2.48.0"
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
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

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}
