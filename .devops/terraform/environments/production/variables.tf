variable "cluster_name" {
  default = "scaling-cluster"
}

variable "prefix" {
  default = "scaling"
}

variable "root_domain" {
  default = "scaling.cloud"
}

variable "api_domain" {
  default = "api.scaling.cloud"
}

variable "resolver_name" {
  default = "consul-dc1"
}

variable "use_existing_route53_zone" {
  type    = bool
  default = true
}

variable "common_tags" {
  default = {
    Environment = "Production"
    Project     = "scaling-cloud"
    Owner       = "erik@erikvandam.dev"
    ManagedBy   = "Terraform"
  }
}
