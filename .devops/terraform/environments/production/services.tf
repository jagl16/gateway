resource "helm_release" "hello_world" {
  name      = "hello-world-service"
  chart     = "./helm-charts/hello-world-service"
  namespace = "services"

  depends_on = [
    helm_release.ambassador,
    helm_release.consul,
  ]
}
