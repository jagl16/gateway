variable "bucket" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "common_tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "Creates a unique resource beginning with the specified prefix."
  type        = string
  default     = null
}

variable "acl" {
  default = "public-read"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket."
  type        = bool
  default     = true
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached."
  type        = bool
  default     = true
}

variable "policy" {
  description = "A valid policy JSON document."
  type        = string
  default     = null
}
