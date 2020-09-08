variable "vpc_cidr" {
  description = "The CIDR block of the VPC."
}

variable "vpc_public_subnets" {
  description = "List of IDs of public subnets."
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "List of IDs of private subnets."
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
}

variable "common_tags" {
  description = "List of common tags."
}

variable "prefix" {
  description = "Prefix for resources."
}

