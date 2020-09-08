variable "domain" {
  description = "A domain name for which the certificate should be issued."
  type        = string
}

variable "use_existing_route53_zone" {
  default     = true
  description = ""
}

variable "common_tags" {
  description = "List of common tags."
}

variable "prefix" {
  description = "Prefix for resources."
}

variable "alternative_domains" {
  description = "List of alternative domains."
  default     = []
}
