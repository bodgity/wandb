resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.35.0" # check latest stable

  values = [
    file("${path.module}/values-argocd.yaml")
  ]
  wait = false
}

resource "kubernetes_manifest" "argocd_wandb_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "wandb"
      namespace = helm_release.argocd.namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/bodgity/wandb.git"
        targetRevision = "official"
        path           = "charts/"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "wandb-cr"
      }
      syncPolicy = {
        automated = {
          prune = true
          selfHeal = true
        }
      }
    }
  }
}
