variable "db_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type       = list(string)
}

variable "eks_cluster_security_group_id" {
  type = string
}

variable "eks_node_security_group_id" {
  type = string
}