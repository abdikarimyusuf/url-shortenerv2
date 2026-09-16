variable "project_name" {
  description = "The name of the project"
  type        = string

}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "visibility_timeout" {
  description = "The visibility timeout for the SQS queue in seconds"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "The message retention period for the SQS queue in seconds"
  type        = number
  default     = 345600
}

variable "main_queue_message_retention_seconds" {
  description = "The message retention period for the main SQS queue in seconds"
  type        = number
  default     = 345600
}
variable "main_queue_visibility_timeout_seconds" {
  description = "The visibility timeout for the main SQS queue in seconds"
  type        = number
  default     = 30
}

variable "max_receive_count" {
  description = "The maximum number of times a message can be received before being sent to the dead-letter queue"
  type        = number
  default     = 5
}

