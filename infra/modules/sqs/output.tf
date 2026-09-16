output "queue_id" {
  value       = aws_sqs_queue.main_queue.id
  description = "The ID of the SQS queue"
}

output "queue_url" {
  value       = aws_sqs_queue.main_queue.url
  description = "The URL of the SQS queue"
}

output "queue_arn" {
  value       = aws_sqs_queue.main_queue.arn
  description = "The ARN of the SQS queue"
}

output "dead_letter_queue_url" {
  value       = aws_sqs_queue.dead_letter_queue.url
  description = "The URL of the dead letter SQS queue"
}

output "dead_letter_queue_arn" {
  value       = aws_sqs_queue.dead_letter_queue.arn
  description = "The ARN of the dead letter SQS queue"
}