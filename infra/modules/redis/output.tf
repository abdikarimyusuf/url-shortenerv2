output "redis_primary_endpoint" {
  description = "Primary Redis endpoint"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address

}

output "redis_port" {
  description = "redis port"
  value       = aws_elasticache_replication_group.redis.port

}

output "redis_id" {
  description = "Redis replication group ID"
  value       = aws_elasticache_replication_group.redis.id

}