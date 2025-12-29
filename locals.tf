locals {
  common_tags = {
    Project     = "wandb"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
