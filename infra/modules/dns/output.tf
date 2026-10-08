output "alb_certificate_arn" {
  description = "alb ACM certificate ARN"
  value       = aws_acm_certificate.alb_certificate.arn
}

output "app_domain_name" {
  description = "Application domain"
  value       = aws_route53_record.app.fqdn
}

output "hosted_zone_id" {
  description = "hostes zone id"
  value       = data.aws_route53_zone.dns.zone_id
}


output "cloudfront_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.cloudfront.arn
}
