data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
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
      asg_desired_capacity = 3
      asg_max_size         = 5
      asg_min_size         = 3
      autoscaling_enabled  = true
    }
  ]

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-eks")
  )
}
