resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  namespace  = "consul"

  depends_on = [
    module.eks,
    kubernetes_namespace.consul,
  ]

  values = [
    <<-EOF
    global:
      name: consul
      acls:
        manageSystemACLs: false

    ui:
      enabled: true

    server:
      replicas: 2
      bootstrapExpect: 2

    syncCatalog:
      enabled: true

    connectInject:
      enabled: true
      k8sAllowNamespaces: ["*"]
    EOF
  ]
}
