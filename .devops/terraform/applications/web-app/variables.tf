variable "dns_root_domain" {
  description = "Root domain the application will be hosted on."
  type        = string
}

variable "domain" {
  description = "Domain the application will be hosted."
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
