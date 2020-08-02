locals {
  environment = terraform.workspace

  prefix = lookup({
    default = "${local.environment}-${var.prefix}"
  }, local.environment)

  vpc_cidr = lookup({
    default = "10.0.0.0/16"
  }, local.environment)

  vpc_public_subnets = lookup({
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  }, local.environment)

  vpc_private_subnets = lookup({
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }, local.environment)

  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}
