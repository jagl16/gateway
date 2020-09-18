variable "domain" {
  description = "A domain name for which the certificate should be issued."
  type        = string
}

variable "dns_zone_id" {
  description = "Zone ID of Route53 zone."
  type        = string
}

variable "common_tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = " Creates a unique resource beginning with the specified prefix."
  type        = string
}

variable "alternative_domains" {
  description = "List of alternative domains."
  default     = []
  type        = list(string)
}
