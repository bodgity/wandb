resource "kubernetes_namespace" "wandb-cr" {
  metadata {

    name = var.namespace
  }
  depends_on = [ module.eks ]
}

resource "kubernetes_secret" "wandb_db" {
  metadata {
    name      = "wandb-db"
    namespace = var.namespace
  }
  data = {
    password = var.db_password
  }
  depends_on = [ module.eks ]
}

resource "kubernetes_storage_class" "gp3_default" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner  = "ebs.csi.aws.com"
  volume_binding_mode  = "WaitForFirstConsumer"
  reclaim_policy       = "Delete"

  parameters = {
    type          = "gp3"
    fsType        = "ext4"
    encrypted     = "true"
  }
  depends_on = [ module.eks ]
}


module "eks" {
  source = "./modules/eks"

  project = var.project
  environment = var.environment
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  artifacts_bucket_arn = module.storage.artifacts_bucket_arn
  
}

module "acm" {
  source = "./modules/acm"

  zone_id = var.zone_id
  wandb_domain = var.wandb_domain
  subdomain = var.subdomain
  public_access = var.public_access
  external_dns = var.external_dns
  acm_certificate_arn = var.acm_certificate_arn
}

module "lb_controller" {
  source = "./modules/lb_controller"

  namespace       = "kube-system"
  cluster_name    = module.eks.eks_cluster_name      
    oidc_provider = {
      arn = module.eks.eks_oidc_provider_arn
      url = module.eks.eks_oidc_provider
  }
  aws_loadbalancer_controller_image_repository = "public.ecr.aws/eks/aws-load-balancer-controller"

  depends_on = [ module.eks ]
}

module "argocd" {
  source = "./modules/argocd"

  depends_on = [ module.lb_controller ]
}

module "networking" {
  source = "./modules/networking"

  aws_region = var.aws_region
  project = var.project
  environment = var.environment
}

module "rds" {
  source = "./modules/rds"

  db_password = var.db_password
  eks_cluster_security_group_id = module.eks.eks_cluster_security_group_id
  eks_node_security_group_id = module.eks.eks_node_security_group_id
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
}

module "storage" {
  source = "./modules/storage"

  environment = var.environment
}