resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }

  lifecycle {
    create_before_destroy = true
  }
}
