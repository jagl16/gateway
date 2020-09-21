data "aws_route53_zone" "dns_zone" {
  count = var.use_existing_route53_zone ? 1 : 0

  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_zone" "dns_zone" {
  count = ! var.use_existing_route53_zone ? 1 : 0
  name  = var.root_domain
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "scaling-cloud-tfstate-erik.vandam"
    key            = "prod.core.scaling-cloud.tfstate"
    region         = "eu-west-1"
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = var.cluster_name
  common_tags  = var.common_tags
  prefix       = var.prefix
  subnets      = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id

  worker_groups_launch_template = [
    {
      name                 = "worker-group-1"
      instance_type        = "t3.large"
      asg_desired_capacity = 3
      asg_max_size         = 5
      asg_min_size         = 2
      autoscaling_enabled  = true
    }
  ]
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

  depends_on = [
    module.eks,
  ]
}

module "ambassador" {
  source = "../../modules/ambassador"

  depends_on = [
    module.eks,
    module.consul,
  ]

  ambassador_hostname = var.api_domain
  consul_host         = format("consul-server.%s.svc.cluster.local:8500", module.consul.consul_namespace)
  acm_certificate_arn = module.acm.acm_certificate_arn
  resolver_name       = var.resolver_name
}
