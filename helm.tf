resource "helm_release" "wandb_operator" {
  name       = "operator"
  namespace  = "wandb-cr"
  repository = "https://charts.wandb.ai"
  chart      = "operator"

  create_namespace = true
}
