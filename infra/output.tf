output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "alb_security_group_id" {
  value       = module.security_groups.alb_security_group_id
  description = "Security group ID for the ALB"
}

output "ecs_security_group_id" {
  value       = module.security_groups.ecs_security_group_id
  description = "Security group ID for the ECS"
}

output "rds_security_group_id" {
  value       = module.security_groups.rds_security_group_id
  description = "Security group ID for the RDS"
}

output "redis_security_group_id" {
  value       = module.security_groups.redis_security_group_id
  description = "Security group ID for the Redis"
}

output "vpc_endpoint_security_group_id" {
  value       = module.security_groups.vpc_endpoint_security_group_id
  description = "Security group ID for the VPC Endpoint"
}

output "repository_url" {
  value       = module.ecr.repository_url
  description = "The URL of the ECR repository"
}

output "sqs_queue_url" {
  value       = module.sqs.queue_url
  description = "The URL of the SQS queue"
}

output "sqs_queue_arn" {
  value       = module.sqs.queue_arn
  description = "The ARN of the SQS queue"
}

output "sqs_dead_letter_queue_arn" {
  value       = module.sqs.dead_letter_queue_arn
  description = "The ARN of the dead letter SQS queue"
}

output "redis_primary_endpoint" {
  description = "Primary Redis endpoint."
  value       = module.redis.redis_primary_endpoint
}

output "redis_port" {
  description = "Redis port."
  value       = module.redis.redis_port
}

output "ecs_cluster_arn" {
  description = "ecs cluster arn"
  value       = module.ecs_cluster.cluster_arn

}


output "api_ecs_service_name" {
  description = "api ecs service name"
  value       = var.deploy_app_services ? module.api_service[0].service_name : null
}

output "worker_ecs_service_name" {
  description = "worker ecs service name"
  value       = var.deploy_app_services ? module.worker_service[0].service_name : null
}

output "dashboard_ecs_service_name" {
  description = "dashboard ecs service name"
  value       = var.deploy_app_services ? module.dashboard_service[0].service_name : null
}
output "waf_web_acl_arn" {
  description = "wag web acl ARN"
  value       = module.waf.web_acl_arn
}

output "frontend_bucket_name" {
  description = "name for the frontend bucket"
  value       = module.cloudfront.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "alb_certificate_arn" {
  description = "alb certificate arn"
  value       = module.dns.alb_certificate_arn
}