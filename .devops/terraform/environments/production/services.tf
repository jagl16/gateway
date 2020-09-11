resource "helm_release" "hello_world" {
  name      = "hello-world-service"
  chart     = "../../../helm-charts/hello-world-service"
  namespace = "services"

  depends_on = [
    kubernetes_namespace.services,
    helm_release.ambassador,
    helm_release.consul,
  ]
}
