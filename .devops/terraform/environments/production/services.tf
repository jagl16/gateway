resource "helm_release" "hello_world" {
  name      = "hello-world-service"
  chart     = "../../../kubernetes/helm/charts/hello-world-service"
  namespace = "services"

  depends_on = [
    kubernetes_namespace.services,
    module.consul,
    module.ambassador,
  ]
}

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }

  lifecycle {
    create_before_destroy = true
  }
}
