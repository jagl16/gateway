variable "cluster_name" {
  default = "scaling-cluster"
}

variable "prefix" {
  default = "scaling"
}

variable "root_domain" {
  default = "scaling.cloud"
}

variable "app_domain" {
  default = "app.scaling.cloud"
}

variable "api_domain" {
  default = "api.scaling.cloud"
}

variable "use_existing_route53_zone" {
  default = true
}

variable "resolver_name" {
  default = "consul-dc1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "common_tags" {
  default = {
    Environment = "Production"
    Project     = "scaling-cloud"
    Owner       = "erik@erikvandam.dev"
    ManagedBy   = "Terraform"
  }
}
