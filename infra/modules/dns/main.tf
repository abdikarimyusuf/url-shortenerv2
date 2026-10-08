data "aws_route53_zone" "dns" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "alb_certificate" {
  domain_name       = "${var.subdomain}.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.subdomain}.${var.domain_name}-cert"
  }

}

resource "aws_route53_record" "cert_vali" {
  for_each = {
    for domainvalidationoption in aws_acm_certificate.alb_certificate.domain_validation_options : domainvalidationoption.domain_name => {
      name   = domainvalidationoption.resource_record_name
      record = domainvalidationoption.resource_record_value
      type   = domainvalidationoption.resource_record_type
    }
  }

  allow_overwrite = true

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.dns.zone_id
}

resource "aws_acm_certificate_validation" "wait_val" {
  certificate_arn = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_vali : record.fqdn
  ]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}



resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}


resource "aws_acm_certificate" "cloudfront" {
  provider = aws.us_east_1

  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_vali" {
  for_each = {
    for domainvalidationoption in aws_acm_certificate.cloudfront.domain_validation_options : domainvalidationoption.domain_name => {
      name   = domainvalidationoption.resource_record_name
      record = domainvalidationoption.resource_record_value
      type   = domainvalidationoption.resource_record_type
    }
  }

  allow_overwrite = true

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.dns.zone_id
}


resource "aws_acm_certificate_validation" "cloudfront_wait_val" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cloudfront_cert_vali : record.fqdn
  ]
}