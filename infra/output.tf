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
    value = module.security_groups.alb_security_group_id
    description = "Security group ID for the ALB"
}

output "ecs_security_group_id" {
    value = module.security_groups.ecs_security_group_id
    description = "Security group ID for the ECS"
}

output "rds_security_group_id" {
    value = module.security_groups.rds_security_group_id
    description = "Security group ID for the RDS"
}

output "redis_security_group_id" {
    value = module.security_groups.redis_security_group_id
    description = "Security group ID for the Redis"
}

output "vpc_endpoint_security_group_id" {
    value = module.security_groups.vpc_endpoint_security_group_id
    description = "Security group ID for the VPC Endpoint"
}