resource "aws_s3_bucket" "wandb_artifacts" {
  bucket = "wandb-artifacts-${var.environment}-joshross"

  tags = {
    Application = "wandb"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.wandb_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
