resource "kubernetes_manifest" "wandb_server" {
  manifest = yamldecode(
    templatefile("${path.module}/wandb.yaml.tpl", {
      namespace        = var.namespace
      wandb_domain     = var.wandb_domain
      aws_region       = var.aws_region
      artifact_bucket = aws_s3_bucket.wandb_artifacts.bucket
      db_host          = aws_db_instance.wandb.address
    })
  )

  depends_on = [
    helm_release.wandb_operator,
    kubernetes_secret.wandb_db,
    aws_db_instance.wandb
  ]
}

resource "kubernetes_secret" "wandb_db" {
  metadata {
    name      = "wandb-db"
    namespace = var.namespace
  }

  data = {
    password = var.db_password
  }
}
