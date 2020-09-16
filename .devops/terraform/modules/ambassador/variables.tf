variable "acm_certificate_arn" {
  description = "The ARN of the certificate used to terminate TLS at the load balancer."
  type        = string
}

variable "resolver_name" {
  description = "The consul resolver name."
  type        = string
}

variable "consul_host" {
  description = "The consul resolver host."
  type        = string
}

variable "ambassador_hostname" {
  description = "The hostname the API gateway will be hosted on."
  type        = string
}
