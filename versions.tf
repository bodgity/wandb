provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      GithubRepo = "wandb"
      GithubOrg  = "bodgity"
      Enviroment = "Example"
      Example    = "PublicDnsExternal"
    }
  }
}