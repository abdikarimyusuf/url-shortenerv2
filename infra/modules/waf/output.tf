output "web_acl_id" {
  description = "web acl ID"
  value       = aws_wafv2_web_acl.web_acl.id
}

output "web_acl_arn" {
  description = "web acl ARN"
  value       = aws_wafv2_web_acl.web_acl.arn
}

output "web_acl_name" {
  description = "web acl NAME"
  value       = aws_wafv2_web_acl.web_acl.name
}