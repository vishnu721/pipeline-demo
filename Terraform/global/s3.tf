resource "aws_s3_bucket" "vishnu-remote" {
  bucket = "vishnu-remote"
  versioning {
      enabled = true
    }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "Name" = "vishnu-remote"
    "Description" = "Terraform remote state s3 bucket"
  }
}