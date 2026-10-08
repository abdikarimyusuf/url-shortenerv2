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



variable "database_secret_arn" {
  type        = string
  description = "ARN of the database credentials secret"
}