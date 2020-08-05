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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.2.0"

  cluster_name = local.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets      = concat(module.vpc.private_subnets, module.vpc.public_subnets)

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
