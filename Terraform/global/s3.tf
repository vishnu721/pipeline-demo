resource "aws_s3_bucket" "s3-bucket" {
  bucket = "terraform-remote-state"
  versioning {
      enabled = True
    }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "Name" = "terraform-remote-state"
    "Description" = "Terraform remote state s3 bucket"
  }
}