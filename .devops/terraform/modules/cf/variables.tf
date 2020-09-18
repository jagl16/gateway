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

variable "price_class" {
  description = ""
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = ""
  type        = string
  default     = "index.html"
}

variable "is_ipv6_enabled" {
  description = ""
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "The ARN of the certificate used to enable HTTPS."
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = ""
  type        = string
  default     = "sni-only"
}

variable "aliases" {
  description = "Aliases or CNAMES for the distribution."
  type        = list(string)
  default     = []
}

variable "s3_origin_config" {
  description = "Configuration for the S3 origin."
  type        = list(map(string))
  default     = []
}

variable "origin_config" {
  description = "Configuration for the origin."
  type        = any
  default     = []
}

variable "default_cache_behavior" {
  description = "Default cache behaviors to be used."
  type        = any
}

variable "cloudfront_default_certificate" {
  description = ""
  type        = bool
  default     = false
}

variable "restriction_type" {
  description = ""
  default     = "none"
}

variable "restriction_locations" {
  description = ""
  default     = []
}
