# ============================================================================
# CLOUDFRONT DISTRIBUTION
# ============================================================================

# S3 Bucket for static assets
resource "aws_s3_bucket" "primeweb_assets" {
  bucket = "primeweb-assets-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "primeweb-assets"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "primeweb_assets" {
  bucket = aws_s3_bucket.primeweb_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "primeweb_assets" {
  bucket = aws_s3_bucket.primeweb_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "primeweb_assets" {
  bucket = aws_s3_bucket.primeweb_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "primeweb" {
  comment = "PrimeWeb OAI"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "primeweb_assets" {
  bucket = aws_s3_bucket.primeweb_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudFrontAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.primeweb.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.primeweb_assets.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "primeweb" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  # S3 Origin (Static Assets)
  origin {
    domain_name = aws_s3_bucket.primeweb_assets.bucket_regional_domain_name
    origin_id   = "S3-primeweb-assets"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.primeweb.cloudfront_access_identity_path
    }
  }

  # ALB Origin (Backend API)
  origin {
    domain_name = aws_lb.primeweb.dns_name
    origin_id   = "ALB-primeweb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    origin_custom_header {
      name  = "X-Origin-Verify"
      value = random_password.cloudfront_header.result
    }
  }

  # Default cache behavior (S3 assets)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-primeweb-assets"
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # API cache behavior
  cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-primeweb"
    compress         = true

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # Health check cache behavior
  cache_behavior {
    path_pattern     = "/health"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-primeweb"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Logging
  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.primeweb_logs.bucket_regional_domain_name
    prefix          = "cloudfront/"
  }

  tags = {
    Name = "primeweb-cloudfront"
  }

  depends_on = [aws_lb.primeweb]
}

# S3 Bucket for CloudFront logs
resource "aws_s3_bucket" "primeweb_logs" {
  bucket = "primeweb-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "primeweb-logs"
  }
}

# Block public access for logs bucket
resource "aws_s3_bucket_public_access_block" "primeweb_logs" {
  bucket = aws_s3_bucket.primeweb_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Logs bucket lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "primeweb_logs" {
  bucket = aws_s3_bucket.primeweb_logs.id

  rule {
    id     = "delete-old-logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

# Random password for CloudFront header verification
resource "random_password" "cloudfront_header" {
  length  = 32
  special = true
}
