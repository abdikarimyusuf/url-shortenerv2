output "ecs_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn

}

output "ecs_api_role_arn" {
  description = "ARN of the ECS api role"
  value       = aws_iam_role.api_task.arn

}


output "ecs_worker_role_arn" {
  description = "ARN of the ECS worker role"
  value       = aws_iam_role.worker_role.arn

}

output "ecs_dashboard_role_arn" {
  description = "ARN of the ECS dashboard role"
  value       = aws_iam_role.dashboard_role.arn

}





