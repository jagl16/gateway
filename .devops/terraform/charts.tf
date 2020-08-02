resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_namespace" "ambassador" {
  metadata {
    name = "ambassador"
  }
}

resource "helm_release" "consul" {
  name       = "${local.prefix}-consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  namespace  = "consul"

  set {
    name  = "server.replicas"
    value = "1"
  }

  set {
    name  = "server.bootstrapExpect"
    value = "1"
  }

  set {
    name  = "global.name"
    value = "consul"
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

resource "helm_release" "ambassador" {
  name       = "${local.prefix}-ambassador"
  repository = "https://www.getambassador.io"
  chart      = "ambassador"
  namespace  = "ambassador"

  set {
    name  = "adminService.create"
    value = "false"
  }

  set {
    name  = "namespace.name"
    value = "ambassador"
  }

  set {
    name  = "service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
    type  = "string"
  }
}
