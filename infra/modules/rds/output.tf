output "db_instance_id" {
  value       = aws_db_instance.db_instance.id
  description = "The ID of the RDS instance"

}

output "db_instance_arn" {
  value       = aws_db_instance.db_instance.arn
  description = "The ARN of the RDS instance"
}

output "db_instance_endpoint" {
  value       = aws_db_instance.db_instance.endpoint
  description = "The endpoint of the RDS instance"
}


output "db_instance_port" {
  value       = aws_db_instance.db_instance.port
  description = "The port of the RDS instance"
}

output "db_name" {
  value       = aws_db_instance.db_instance.db_name
  description = "The name of the RDS database"
}

output "master_user_secret_arn" {
  value       = aws_db_instance.db_instance.master_user_secret[0].secret_arn
  description = "The ARN of the master user secret for the RDS instance"
}