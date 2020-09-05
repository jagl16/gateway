resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  namespace  = "consul"

  depends_on = [
    module.eks,
    kubernetes_namespace.consul,
  ]

  set {
    name  = "server.replicas"
    value = "1"
  }

  set {
    name  = "server.bootstrapExpect"
    value = "1"
  }

  set {
    name  = "ui.enabled"
    value = "true"
  }

  set {
    name  = "syncCatalog.enabled"
    value = "true"
  }

  set {
    name  = "connectInject.enabled"
    value = "true"
  }
}
