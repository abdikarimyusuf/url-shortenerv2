output "alb_security_group_id" {
    value = aws_security_group.alb.id
    description = "Security group ID for the ALB"
}  

output "ecs_security_group_id" {
    value = aws_security_group.ecs.id
    description = "Security group ID for the ECS"
}

output "rds_security_group_id" {
    value = aws_security_group.rds.id
    description = "Security group ID for the RDS"
}

output "redis_security_group_id" {
    value = aws_security_group.redis.id
    description = "Security group ID for the Redis"
}

output "vpc_endpoint_security_group_id" {
    value = aws_security_group.vpc_endpoint.id
    description = "Security group ID for the VPC Endpoint"
}