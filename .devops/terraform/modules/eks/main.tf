data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.2.0"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
  subnets      = var.subnets

  workers_additional_policies = [
    aws_iam_policy.autoscaler_policy.arn,
  ]

  worker_groups_launch_template = var.worker_groups_launch_template

  tags = merge(
    var.common_tags,
    map("Name", "${var.prefix}-eks")
  )
}
