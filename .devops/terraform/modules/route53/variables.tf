variable "zone_id" {
  description = "ID of DNS zone."
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Name of DNS zone."
  type        = string
  default     = null
}

variable "records" {
  description = "List of maps of DNS records."
  type        = any
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
