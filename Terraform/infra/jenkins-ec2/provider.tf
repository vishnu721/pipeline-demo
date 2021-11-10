terraform {
  backend "s3" {
    bucket = "vishnu-remote"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}