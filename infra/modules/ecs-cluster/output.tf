
output "cluster_id" {
  description = "cluster id"
  value       = aws_ecs_cluster.cluster.id
}

output "cluster_arn" {
  description = "cluster arn"
  value       = aws_ecs_cluster.cluster.arn
}

output "cluster_name" {
  description = "cluster name"
  value       = aws_ecs_cluster.cluster.name

}