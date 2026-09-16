output "service_id" {
  description = "service id "
  value       = aws_ecs_service.servcie.id

}

output "service_name" {
  value = aws_ecs_service.servcie.name

}

output "task_def_arn" {
  description = "task def arn"
  value       = aws_ecs_task_definition.task_def.arn

}

output "log_group_name" {
  description = "log group name"
  value       = aws_cloudwatch_log_group.cloudwatch.name

}