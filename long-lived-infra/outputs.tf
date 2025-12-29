output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.eks_cluster_security_group_id
}

output "eks_node_security_group_id" {
  value = module.eks.eks_node_security_group_id
}

output "eks_oidc_provider_arn" {
  value = module.eks.eks_oidc_provider_arn
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}