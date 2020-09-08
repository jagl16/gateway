variable "cluster_name" {
  description = "Name of the EKS cluster."
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "common_tags" {
  description = "List of common tags."
}

variable "prefix" {
  description = "Prefix for resources."
}
