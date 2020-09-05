resource "helm_release" "hello_world" {
  name      = "hello-world-service"
  chart     = "./helm-charts/hello-world-service"
  namespace = "services"

  set {
    name  = "fullnameOverride"
    value = "hello-world-service"
  }

  depends_on = [
    helm_release.ambassador,
    helm_release.consul,
  ]
}
