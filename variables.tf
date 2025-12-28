variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "wandb_domain" {
  type        = string
  description = "Public domain for W&B (e.g. wandb.example.com)"
}

variable "namespace" {
  type        = string
  default     = "wandb-cr"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "db_password" {
  type      = string
  sensitive = true
}
