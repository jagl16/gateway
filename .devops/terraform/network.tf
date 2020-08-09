module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.6"

  name            = "${local.prefix}-vpc"
  cidr            = local.vpc_cidr
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = local.vpc_public_subnets
  private_subnets = local.vpc_private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-vpc")
  )
}
