terraform {
  backend "s3" {
      bucket = "vishnu-remote"
      key = "jenkinsnode/terraform.tfstate"
      region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}