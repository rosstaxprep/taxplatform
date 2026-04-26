# ============================================================================
# ROUTE53 DNS CONFIGURATION
# ============================================================================

# Hosted Zone (if not already created)
resource "aws_route53_zone" "primeweb" {
  name = "rosstaxsoftware.com"

  tags = {
    Name = "rosstaxsoftware-zone"
  }
}

# Primary domain record (CloudFront)
resource "aws_route53_record" "primeweb_cloudfront" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "primeweb.rosstaxsoftware.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.primeweb.domain_name
    zone_id                = aws_cloudfront_distribution.primeweb.hosted_zone_id
    evaluate_target_health = false
  }
}

# WWW subdomain
resource "aws_route53_record" "primeweb_www" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "www.primeweb.rosstaxsoftware.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.primeweb.domain_name
    zone_id                = aws_cloudfront_distribution.primeweb.hosted_zone_id
    evaluate_target_health = false
  }
}

# API subdomain (direct to ALB)
resource "aws_route53_record" "primeweb_api" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "api.primeweb.rosstaxsoftware.com"
  type    = "A"

  alias {
    name                   = aws_lb.primeweb.dns_name
    zone_id                = aws_lb.primeweb.zone_id
    evaluate_target_health = true
  }
}

# Health check for primary domain
resource "aws_route53_health_check" "primeweb" {
  fqdn              = aws_lb.primeweb.dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "primeweb-health-check"
  }
}

# ACM Certificate validation records
resource "aws_route53_record" "primeweb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.primeweb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primeweb.zone_id
}

# Certificate validation
resource "aws_acm_certificate_validation" "primeweb" {
  certificate_arn           = aws_acm_certificate.primeweb.arn
  timeouts {
    create = "5m"
  }

  depends_on = [aws_route53_record.primeweb_cert_validation]
}

# MX records for email
resource "aws_route53_record" "primeweb_mx" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "rosstaxsoftware.com"
  type    = "MX"
  ttl     = 3600

  records = [
    "10 aspmx.l.google.com",
    "20 alt1.aspmx.l.google.com",
    "30 alt2.aspmx.l.google.com",
    "40 alt3.aspmx.l.google.com",
    "50 alt4.aspmx.l.google.com"
  ]
}

# SPF record
resource "aws_route53_record" "primeweb_spf" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "rosstaxsoftware.com"
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}

# DKIM record (Google Workspace)
resource "aws_route53_record" "primeweb_dkim" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "google._domainkey.rosstaxsoftware.com"
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA..." # Replace with actual DKIM key
  ]
}

# DMARC record
resource "aws_route53_record" "primeweb_dmarc" {
  zone_id = aws_route53_zone.primeweb.zone_id
  name    = "_dmarc.rosstaxsoftware.com"
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=DMARC1; p=quarantine; rua=mailto:dmarc@rosstaxsoftware.com"
  ]
}

# CloudWatch Alarm for health check
resource "aws_cloudwatch_metric_alarm" "primeweb_health" {
  alarm_name          = "primeweb-health-check-failed"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "Alert when PrimeWeb health check fails"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.primeweb.id
  }
}
