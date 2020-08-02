terraform {
  required_version = ">= 0.12.9"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

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
    "kubernetes.io/cluster/${local.prefix}" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.prefix}" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
  }

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-vpc")
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.2.0"

  cluster_name = "${local.prefix}-cluster"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets

  workers_additional_policies = [
    aws_iam_policy.autoscaler_policy.arn
  ]

  worker_groups_launch_template = [
    {
      name                 = "worker-group-1"
      instance_type        = "t3.large"
      asg_desired_capacity = 1
      asg_max_size         = 2
      asg_min_size         = 1
      autoscaling_enabled  = true
    }
  ]

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-eks")
  )
}
