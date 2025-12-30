locals {
  create_certificate = var.public_access && var.acm_certificate_arn == null

  fqdn = var.subdomain == null ? var.wandb_domain : "${var.subdomain}.${var.wandb_domain}"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  create_certificate = local.create_certificate

  subject_alternative_names = var.extra_fqdn

  domain_name = var.external_dns ? local.fqdn : var.wandb_domain
  zone_id     = var.zone_id

  wait_for_validation = true
}

