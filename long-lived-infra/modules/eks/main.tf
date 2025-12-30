module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project}-${var.environment}-eks"
  cluster_version = "1.32"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {}
    vpc-cni = {service_account_role_arn = aws_iam_role.oidc.arn}
    kube-proxy = {}
    aws-ebs-csi-driver = {}
  }

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.2xlarge"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}





