module "eks" {
  source = "../../modules/eks"

  cluster_name = var.cluster_name
  common_tags  = var.common_tags
  prefix       = var.prefix
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id

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

module "vpc" {
  source = "../../modules/vpc"

  cluster_name        = var.cluster_name
  common_tags         = var.common_tags
  prefix              = var.prefix
  vpc_cidr            = var.vpc_cidr
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets
}

module "acm" {
  source = "../../modules/acm"

  common_tags = var.common_tags
  domain      = var.root_domain
  prefix      = var.prefix
  alternative_domains = [
    var.app_domain,
    var.api_domain,
  ]
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
