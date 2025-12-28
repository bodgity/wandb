terraform {
  backend "s3" {
    bucket       = "tf-state-joshross"
    key          = "wandb/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}