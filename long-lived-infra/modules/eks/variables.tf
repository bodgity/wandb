variable "project" {
  type        = string
  description = "Project name"
}

variable "namespace" {
  type       = string
  default    = "wandb-cr"
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
}

variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type       = list(string)
}