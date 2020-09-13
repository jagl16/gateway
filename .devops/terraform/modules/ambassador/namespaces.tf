resource "kubernetes_namespace" "ambassador" {
  metadata {
    name = "ambassador"
  }

  lifecycle {
    create_before_destroy = true
  }
}
