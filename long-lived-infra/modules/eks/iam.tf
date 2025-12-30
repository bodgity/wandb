### IAM policy and role for vpc-cni
data "aws_iam_policy_document" "oidc_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_oidc" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.oidc.name
}

resource "aws_iam_role" "oidc" {
  name               = join("-", [var.project, "oidc"])
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role.json
}

resource "aws_iam_policy" "wandb_s3" {
  name        = "wandb-s3-access"
  description = "Read/write access to W&B artifacts bucket only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketList"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.artifacts_bucket_arn
      },
      {
        Sid    = "ObjectRW"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = "${var.artifacts_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.wandb_s3.arn
}