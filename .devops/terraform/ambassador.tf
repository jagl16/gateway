resource "helm_release" "ambassador" {
  name       = "ambassador"
  repository = "https://www.getambassador.io"
  chart      = "ambassador"
  namespace  = "ambassador"

  depends_on = [
    module.eks,
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
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
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
    kubernetes_manifest.ambassador_consul_resolver,
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
        xff_num_trusted_hops = 2
        use_remote_address   = false
        resolver             = local.resolver_name
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
      name      = "ambassador"
      namespace = "ambassador"
    }
    spec = {
      hostname = "*"
      selector = {
        matchLabels = {
          hostname = "wildcard"
        }
      }
      acmeProvider = {
        authority = "None"
      }
      requestPolicy = {
        insecure = {
          action = "Route"
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
      name      = local.resolver_name
      namespace = "ambassador"
    }
    spec = {
      address    = format("%s-consul-server.%s.svc.cluster.local:8500", helm_release.consul.name, helm_release.consul.namespace)
      datacenter = "dc1"
    }
  }
}
