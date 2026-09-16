resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-redis-subnet-group"
  }
}


resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "${var.project_name}-${var.environment}-redis"
  description                = "Redis replication group for ${var.project_name} in ${var.environment} environment"
  engine                     = "redis"
  engine_version             = var.redis_engine_version
  node_type                  = var.redis_node_type
  port                       = var.redis_port
  parameter_group_name       = "default.redis7"
  num_cache_clusters         = "1"
  automatic_failover_enabled = false
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = var.security_group_ids
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  multi_az_enabled           = false
  snapshot_retention_limit   = 0
  apply_immediately          = true


  tags = {
    Name = "${var.project_name}-${var.environment}-redis"
  }
}