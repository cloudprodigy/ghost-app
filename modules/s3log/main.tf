resource "aws_s3_bucket" "s3_bucket" {
  #tfsec:ignore:AWS002
  bucket = "${var.account_id}-${var.bucket_name}"
  acl    = "log-delivery-write"
  tags   = local.common_tags

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "alb" {
  count  = var.service == "alb" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.alb.json
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  count  = var.service == "cloudtrail" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

resource "aws_s3_bucket_policy" "general" {
  count  = var.service != "alb" && var.service != "cloudtrail" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.general.json
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
