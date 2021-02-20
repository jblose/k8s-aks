resource "azurerm_resource_group" "aks" {
  name     = "${var.az_service}-${var.az_suffix}-rgp"
  location = "eastus"

  tags = {
    service = var.az_service
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.az_service}${var.az_suffix}"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.az_service}-${var.az_suffix}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "${var.az_service}${var.az_suffix}"
    node_count           = var.node_cnt
    vm_size              = var.node_sku
    orchestrator_version = var.orchestrator_version
    max_pods             = var.max_pods
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
  
  node_resource_group = "${var.az_service}-${var.az_suffix}-nodepool-rgp"

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    service = var.az_service
  }
}

output "client_certificate" {

  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}
