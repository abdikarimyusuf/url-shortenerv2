variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "sqs_queue_arn" {
  description = "ARN of the main SQS click-events queue"
  type        = string

}

variable "rds_secret_arn" {
  description = "ARN of the RDS credentials secret"
  type        = string

}