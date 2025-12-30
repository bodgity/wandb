variable "external_dns" {
  type        = bool
  default     = false
  description = "Using external DNS. A `subdomain` must also be specified if this value is true."
}

variable "extra_fqdn" {
  type        = list(string)
  description = "Additional fqdn's must be in the same hosted zone as `domain_name`."
  default     = []
}

variable "public_access" {
  type        = bool
  default     = false
  description = "Is this instance accessable a public domain."
}

variable "subdomain" {
  type        = string
  default     = null
  description = "Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route."
}

variable "acm_certificate_arn" {
  type        = string
  default     = null
  description = "The ARN of an existing ACM certificate."
}

variable "wandb_domain" {
  type        = string
  description = "Route53 hosted zone domain"
}

variable "zone_id" {
  type        = string
}