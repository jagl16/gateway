resource "helm_release" "ambassador" {
  name       = "${local.prefix}-ambassador"
  repository = "https://www.getambassador.io"
  chart      = "ambassador"
  namespace  = "ambassador"

  depends_on = [
    kubernetes_namespace.ambassador,
  ]

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = module.acm.this_acm_certificate_arn
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "443"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-proxy-protocol"
    value = "*"
    type  = "string"
  }

  values = [
    <<-EOF
    service:
      type: LoadBalancer

      ports:
        - name: http
          port: 80
          targetPort: 8080
        - name: https
          port: 443
          targetPort: 8080
    EOF
  ]
}

resource "kubernetes_manifest" "ambassador_config" {
  provider = kubernetes-alpha

  depends_on = [
    helm_release.ambassador,
    kubernetes_manifest.ambassador_host,
  ]

  manifest = {
    apiVersion = "getambassador.io/v2"
    kind       = "Module"
    metadata = {
      name      = "ambassador"
      namespace = "ambassador"
    }
    spec = {
      config = {
        xff_num_trusted_hops = 1
        use_remote_address   = false
        resolver             = "consul-dc1"
        load_balancer = {
          policy = "round_robin"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "ambassador_host" {
  provider = kubernetes-alpha

  depends_on = [
    helm_release.ambassador,
  ]

  manifest = {
    apiVersion = "getambassador.io/v2"
    kind       = "Host"
    metadata = {
      name      = "scaling.cloud"
      namespace = "ambassador"
    }
    spec = {
      hostname = "scaling.cloud"
      acmeProvider = {
        authority = "None"
      }
      requestPolicy = {
        insecure = {
          action         = "Redirect"
          additionalPort = 8080
        }
      }
    }
  }
}

resource "kubernetes_manifest" "ambassador_consul_resolver" {
  provider = kubernetes-alpha

  depends_on = [
    helm_release.ambassador,
  ]

  manifest = {
    apiVersion = "getambassador.io/v2"
    kind       = "ConsulResolver"
    metadata = {
      name      = "consul-dc1"
      namespace = "ambassador"
    }
    spec = {
      address    = "127.0.0.1:8500"
      datacenter = "dc1"
    }
  }
}
