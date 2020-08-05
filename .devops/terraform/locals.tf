locals {
  environment = terraform.workspace

  cluster_name = "${local.prefix}-cluster"

  domain = "scaling.cloud"

  prefix = "${local.environment}-${var.prefix}"

  use_existing_route53_zone = true

  vpc_cidr = lookup({
    default = "10.0.0.0/16"
    staging = "172.0.0.0/16"
  }, local.environment)

  vpc_public_subnets = lookup({
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    staging = cidrsubnets(local.vpc_cidr, 1, 2, 3)
  }, local.environment)

  vpc_private_subnets = lookup({
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    staging = cidrsubnets(local.vpc_cidr, 4, 5, 6)
  }, local.environment)

  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}
