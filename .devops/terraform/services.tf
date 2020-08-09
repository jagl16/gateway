resource "helm_release" "hello_world" {
  name      = "${var.prefix}-hello-world-service"
  chart     = "../helm-charts/hello-world-service"
  namespace = "services"

  set {
    name  = "host"
    value = "hello.${local.domain}"
  }

  set {
    name  = "name"
    value = "hello-world-service:8080"
  }
  set {
    name  = "fullnameOverride"
    value = "hello-world-service"
  }

  set {
    name  = "secretName"
    value = kubernetes_secret.ambassador-certs.metadata.0.name
  }

  depends_on = [
    helm_release.ambassador,
    helm_release.consul,
  ]
}
