resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "ingress-basic"
  }
}
