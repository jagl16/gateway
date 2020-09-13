resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  namespace  = "consul"

  depends_on = [
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
      replicas: 1
      bootstrapExpect: 1

    syncCatalog:
      enabled: true

    connectInject:
      enabled: true
      k8sAllowNamespaces: ["*"]
    EOF
  ]
}
