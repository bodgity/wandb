module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project}-${var.environment}-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

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

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

module "lb_controller" {
  source = "./modules/lb_controller"

  namespace       = "kube-system"
  cluster_name    = module.eks.cluster_name      
    oidc_provider = {
      arn = module.eks.oidc_provider_arn
      url = module.eks.oidc_provider
  }
  aws_loadbalancer_controller_image_repository = "public.ecr.aws/eks/aws-load-balancer-controller"
}

# Weave worker authentication token
resource "random_password" "weave_worker_auth" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "weave_worker_auth" {
  name                    = "${var.namespace}-weave-worker-auth"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "weave_worker_auth" {
  secret_id     = aws_secretsmanager_secret.weave_worker_auth.id
  secret_string = random_password.weave_worker_auth.result
}

# IAM policy to allow reading the secret
resource "aws_iam_policy" "weave_worker_auth_secret_reader" {
  name        = "${var.namespace}-weave-worker-auth-secret-reader"
  description = "Allow reading weave worker auth secret from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.weave_worker_auth.arn
      }
    ]
  })
}

# Attach the policy to the node role
#resource "aws_iam_role_policy_attachment" "weave_worker_auth_secret_reader" {
#  role       = module.eks.eks_managed_node_groups.iam_role_arn
#  policy_arn = aws_iam_policy.weave_worker_auth_secret_reader.arn
#}

# Create Kubernetes secret with the token
resource "kubernetes_secret" "weave_worker_auth" {
  metadata {
    name      = "weave-worker-auth"
    namespace = var.namespace
  }

  binary_data = {
    "key" = random_password.weave_worker_auth.result
  }

  depends_on = [module.eks]
}