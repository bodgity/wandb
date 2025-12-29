output "wandb_yaml_rendered" {
  value = templatefile("${path.module}/wandb.yaml.tpl", {
    namespace        = var.namespace
    wandb_domain     = var.wandb_domain
    aws_region       = var.aws_region
    artifact_bucket = aws_s3_bucket.wandb_artifacts.bucket
    db_host          = aws_db_instance.wandb.address
    acm_certificate_arn = data.terraform_remote_state.platform.outputs.acm_certificate_arn
  })
}

output "argocd_server_url" {
  value = helm_release.argocd.status
}