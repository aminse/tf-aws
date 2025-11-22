resource "aws_s3_bucket" "sample_bucket" {
  bucket = var.bucket_name

  # Optional: enable versioning
  versioning {
    enabled = true
  }

  # Optional: enable server-side encryption (SSE-S3)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Optional: block all public access
  acl = "private"

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# Optional: Bucket Policy example
resource "aws_s3_bucket_policy" "sample_policy" {
  bucket = aws_s3_bucket.sample_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "${aws_s3_bucket.sample_bucket.arn}/*",
          aws_s3_bucket.sample_bucket.arn
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
