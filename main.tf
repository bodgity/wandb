module "wandb_infra" {
  source  = "wandb/wandb/aws"
  version = "~>7.0"

  license     = var.license
  namespace   = var.namespace
  domain_name = var.domain_name
  subdomain   = var.subdomain
  zone_id     = var.zone_id

  allowed_inbound_cidr           = var.allowed_inbound_cidr
  allowed_inbound_ipv6_cidr      = var.allowed_inbound_ipv6_cidr

  public_access                  = true
  external_dns                   = true
  kubernetes_public_access       = true
  kubernetes_public_access_cidrs = ["0.0.0.0/0"]
  eks_cluster_version            = var.eks_cluster_version
}

 data "aws_eks_cluster" "eks_cluster_id" {
   name = module.wandb_infra.cluster_name
 }

 data "aws_eks_cluster_auth" "eks_cluster_auth" {
   name = module.wandb_infra.cluster_name
 }

 provider "kubernetes" {
   host                   = data.aws_eks_cluster.eks_cluster_id.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_id.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
 }


 provider "helm" {
   kubernetes {
     host                   = data.aws_eks_cluster.eks_cluster_id.endpoint
     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_id.certificate_authority.0.data)
     token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
   }
 }

 output "url" {
   value = module.wandb_infra.url
 }

 output "bucket" {
   value = module.wandb_infra.bucket_name
 }