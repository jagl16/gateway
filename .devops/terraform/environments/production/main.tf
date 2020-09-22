terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket         = "scaling-cloud-tfstate-erik.vandam"
    key            = "prod.gateway.scaling-cloud.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "scaling-cloud-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.1"
    }
  }
}

data "terraform_remote_state" "core" {
  backend = "s3"

  config = {
    bucket         = "scaling-cloud-tfstate-erik.vandam"
    key            = "prod.core.scaling-cloud.tfstate"
    region         = "eu-west-1"
  }
}

data "aws_route53_zone" "dns_zone" {
  count = var.use_existing_route53_zone ? 1 : 0

  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_zone" "dns_zone" {
  count = ! var.use_existing_route53_zone ? 1 : 0
  name  = var.root_domain
}

module "acm" {
  source = "../../modules/acm"

  dns_zone_id = coalescelist(data.aws_route53_zone.dns_zone.*.zone_id, aws_route53_zone.dns_zone.*.zone_id)[0]
  domain      = var.root_domain
  alternative_domains = [
    var.api_domain,
  ]
  prefix      = var.prefix
  common_tags = var.common_tags
}

module "consul" {
  source = "../../modules/consul"
}

module "ambassador" {
  source = "../../modules/ambassador"

  depends_on = [
    module.consul,
  ]

  ambassador_hostname = var.api_domain
  consul_host         = format("consul-server.%s.svc.cluster.local:8500", module.consul.consul_namespace)
  acm_certificate_arn = module.acm.acm_certificate_arn
  resolver_name       = var.resolver_name
}
