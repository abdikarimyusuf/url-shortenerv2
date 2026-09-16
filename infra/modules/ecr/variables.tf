variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "repositories" {
  description = "A list of ECR repositories to create"
  type        = set(string)
}