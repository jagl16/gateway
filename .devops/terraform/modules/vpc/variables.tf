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
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = " Creates a unique resource beginning with the specified prefix."
  type        = string
  default     = null
}
