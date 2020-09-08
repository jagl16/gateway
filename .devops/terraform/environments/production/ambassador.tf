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
    value = module.acm.acm_certificate_arn
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

resource "helm_release" "ambassador_config" {
  name      = "ambassador-config"
  chart     = "./helm-charts/ambassador-config"
  namespace = "ambassador"

  depends_on = [
    kubernetes_namespace.ambassador,
    helm_release.consul,
    helm_release.ambassador,
  ]

  set {
    name  = "resolver.name"
    value = var.resolver_name
  }

  set {
    name  = "consul.host"
    value = format("consul-server.%s.svc.cluster.local:8500", helm_release.consul.namespace)
  }

  set {
    name  = "ambassador.hostname"
    value = var.domain
  }
}
