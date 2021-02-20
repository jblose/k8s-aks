variable "az_suffix" {}
variable "az_service" {}
variable "kubernetes_version" {}
variable "orchestrator_version" {}
variable "node_sku" {}
variable "node_cnt" {}
variable "max_pods"{
    type = number
    default = 30
}
