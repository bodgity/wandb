#resource "kubectl_manifest" "wandb_server" {
#  yaml_body = templatefile("${path.module}/wandb.yaml.tpl", {
#      namespace        = var.namespace
#      wandb_domain     = var.wandb_domain
#      aws_region       = var.aws_region
#      artifact_bucket = aws_s3_bucket.wandb_artifacts.bucket
#      acm_certificate_arn = data.terraform_remote_state.platform.outputs.acm_certificate_arn
#      db_host          = aws_db_instance.wandb.address
#    })
#  wait = true
#  force_new = true

#  depends_on = [
#    helm_release.wandb_operator,
#    kubernetes_secret.wandb_db,
#    aws_db_instance.wandb,
#    aws_s3_bucket.wandb_artifacts
#  ]
#}

resource "kubernetes_secret" "wandb_db" {
  metadata {
    name      = "wandb-db"
    namespace = var.namespace
  }

  data = {
    password = var.db_password
  }
}
