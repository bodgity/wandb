variable "namespace" {
  type        = string
  description = "Name prefix used for resources"
}

variable "domain_name" {
  type        = string
  description = "Domain name used to access instance."
}

variable "subdomain" {
  type        = string
  default     = null
  description = "Subdomain for accessing the Weights & Biases UI."
}

variable "license" {
  type = string
}

variable "zone_id" {
  type        = string
  description = "Domain for creating the Weights & Biases subdomain on."
}

variable "allowed_inbound_cidr" {
 description = "CIDRs allowed to access wandb-server."
 nullable    = false
 type        = list(string)
}

variable "allowed_inbound_ipv6_cidr" {
 description = "CIDRs allowed to access wandb-server."
 nullable    = false
 type        = list(string)
}

variable "eks_cluster_version" {
 description = "EKS cluster kubernetes version"
 nullable    = false
 type        = string
}