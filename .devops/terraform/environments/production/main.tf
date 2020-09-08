module "eks" {
  source = "../../modules/eks"

  cluster_name = var.cluster_name
  common_tags  = var.common_tags
  prefix       = var.prefix
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
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
  domain      = var.domain
  prefix      = var.prefix
}
