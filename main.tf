resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Upload index.html and other files
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "${var.website_folder_path}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "assets" {
  for_each = fileset(var.website_folder_path, "**")
  bucket   = aws_s3_bucket.mybucket.id
  key      = each.value

  # Determine the content type based on file extension
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")

  source = "${var.website_folder_path}/${each.value}"
}

resource "aws_s3_object" "error_404" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "404.html"
  source       = "${var.website_folder_path}/404.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_403" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "403.html"
  source       = "${var.website_folder_path}/403.html"
  content_type = "text/html"
}


resource "aws_acm_certificate" "cert" {
  domain_name       = "carvilla.run.place"
  validation_method = "DNS"

  subject_alternative_names = ["www.carvilla.run.place"]
}


# CloudFront Origin Access Control (OAC) for secure S3 access
resource "aws_cloudfront_origin_access_control" "oac" {
  name                             = "s3-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                 = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution with private S3 access
resource "aws_cloudfront_distribution" "mycdn" {
  origin {
    domain_name = aws_s3_bucket.mybucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.mybucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"
  

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.mybucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false  # Set to true if you want to forward query strings
      cookies {
        forward = "none"  # Change to 'all' if you want to forward cookies
      }
      #headers = ["Origin", "Content-Type", "Authorization"]  # Forward headers explicitly
    }
    #min_ttl         = 0
    #default_ttl     = 3600  # 1 hour
    #max_ttl         = 86400 # 1 day
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/404.html"
    response_code         = 200
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 403
    response_page_path    = "/403.html"
    response_code         = 200
    error_caching_min_ttl = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  aliases = ["carvilla.run.place", "www.carvilla.run.place"]  # Custom domain
  
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
    #minimum_protocol_version = "TLSv1.2_2021"
  }

}

# S3 Bucket Policy to Allow Only CloudFront Access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "${aws_s3_bucket.mybucket.arn}/*"
        Principal = {
          AWS = "*"
        },
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.mycdn.arn}"
          }
        }
      }
    ]
  })
}

# Output for DNS validation
output "acm_dns_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}












