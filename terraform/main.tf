# ─────────────────────────────────────────────
# S3 Bucket
# ─────────────────────────────────────────────
# Website files to be stored here
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_headers = [
      "Content-Type",
      "Authorization",
      "x-amz-date",
      "x-amz-content-sha256",
      "x-amz-security-token"
    ]

    allowed_methods = [
      "GET",
      "PUT",
      "POST",
      "DELETE",
      "HEAD"
    ]

    allowed_origins = [
      "https://${var.domain_name}",
      "https://www.${var.domain_name}"
    ]

    expose_headers = [
      "ETag"
    ]

    max_age_seconds = 3000
  }
}

resource "aws_kms_key" "s3" {
  description         = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket_encrypt" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/../website", "**/*")

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "${path.module}/../website/${each.value}"

  etag = filemd5("${path.module}/../website/${each.value}")
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.website_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : [
              aws_cloudfront_distribution.website_distribution.arn
            ]
          }
        }
      }
    ]
  })
}


resource "aws_s3_bucket" "logs" {
  bucket = "${var.bucket_name}-access-logs"
}

resource "aws_s3_bucket_logging" "website_bucket_logs" {
  bucket        = aws_s3_bucket.website_bucket.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "s3-access-logs/"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-access-logs"
    status = "Enabled"

    filter {
      prefix = "s3-access-logs/"
    }

    expiration {
      days = 90
    }
  }
}

# ─────────────────────────────────────────────
# ACM
# ─────────────────────────────────────────────
# TLS/SSL Certificate

resource "aws_acm_certificate" "website_tls" {
  domain_name = var.domain_name
  subject_alternative_names = [
    "www.${var.domain_name}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_tls.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value

  ttl     = 60
  proxied = false
}

resource "aws_acm_certificate_validation" "tls_validation" {
  certificate_arn = aws_acm_certificate.website_tls.arn

  validation_record_fqdns = [
    for record in cloudflare_dns_record.acm_validation :
    record.name
  ]
}
