resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }

  lifecycle {
    create_before_destroy = true
  }
}
