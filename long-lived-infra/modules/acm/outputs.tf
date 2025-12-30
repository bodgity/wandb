output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}

output "wandb_host" {
  value = local.fqdn
}