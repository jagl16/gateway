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

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}

resource "helm_release" "consul" {
  name       = "${local.prefix}-consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  namespace  = "consul"

  depends_on = [
    module.eks,
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

  depends_on = [
    module.eks,
    module.acm,
  ]

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

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = module.acm.this_acm_certificate_arn
  }
}

resource "helm_release" "ambassador_consul_resolver" {
  name      = "${local.prefix}-ambassador-consul-resolver"
  chart     = "../helm-charts/ambassador-consul-resolver"
  namespace = "ambassador"

  depends_on = [
    helm_release.ambassador,
  ]

  set {
    name  = "resolver.name"
    value = "consul-dc1"
  }

  set {
    name  = "consul.host"
    value = "consul.service.consul"
  }

  set {
    name  = "consul.port"
    value = "8500"
  }

  set {
    name  = "consul.datacenter"
    value = "dc1"
  }
}

//resource "helm_release" "hello_world" {
//  name      = "${var.prefix}-hello-world-service"
//  chart     = "../helm-charts/hello-world-service"
//  namespace = "services"
//
//  depends_on = [
//    helm_release.ambassador,
//    helm_release.consul,
//  ]
//}
