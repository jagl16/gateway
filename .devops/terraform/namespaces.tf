resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "kubernetes_namespace" "ambassador" {
  metadata {
    name = "ambassador"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }

  lifecycle {
    create_before_destroy = true
  }
}
