resource "kubernetes_secret" "ambassador-certs" {
  metadata {
    name      = "ambassador-certs"
    namespace = "ambassador"
  }

  data = {
    "tls.crt" = file("./templates/certs/server.cert")
    "tls.key" = file("./templates/certs/server.key")
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
    kubernetes_namespace.ambassador,
  ]

  values = [
    file(format("%s/%s", "../helm-charts/ambassador", "values.yaml"))
  ]

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
