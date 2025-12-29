variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "eks_cluster_security_group_id" {
  type        = string
  description = "EKS cluster security group ID"
}

variable "eks_node_security_group_id" {
  type        = string
  description = "EKS node security group ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}
