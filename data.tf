data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
    bucket = "tf-state-joshross"
    key    = "platform/terraform.tfstate"
    region = "eu-west-1"
  }
}
