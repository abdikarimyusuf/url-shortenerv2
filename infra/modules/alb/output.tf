output "load_balancer_zone_id" {
  description = "ALB ID"
  value       = aws_lb.alb.zone_id
}

output "load_balancer_arn" {
  description = "alb ARN"
  value       = aws_lb.alb.arn
}

output "load_balancer_arn_suffix" {
  description = "alb ARN"
  value       = aws_lb.alb.arn_suffix
}

output "load_balancer_dns_name" {
  description = "alb dns name"
  value       = aws_lb.alb.dns_name
}

output "api_tg_arn" {
  description = "api tg ARN"
  value       = aws_lb_target_group.api_tg.arn
}
output "api_tg_arn_suffix" {
  description = "api tg ARN"
  value       = aws_lb_target_group.api_tg.arn_suffix
}

output "dashboard_tg_arn" {
  description = "dashboard tg ARN"
  value       = aws_lb_target_group.db_tg.arn
}

output "dashboard_tg_arn_suffix" {
  description = "dashboard tg ARN"
  value       = aws_lb_target_group.db_tg.arn_suffix
}

output "http_listener_arn" {
  description = "listener ARN"
  value       = aws_lb_listener.http.arn
}