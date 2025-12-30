output "artifacts_bucket"{
    value = aws_s3_bucket.wandb_artifacts.bucket
}

output "artifacts_bucket_arn" {
    value = aws_s3_bucket.wandb_artifacts.arn
}

output "artifacts_bucket_region" {
  value = aws_s3_bucket.wandb_artifacts.region
}