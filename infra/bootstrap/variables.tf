variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "url-shortener-bucket"
}

variable "region" {
  description = "The AWS region where the S3 bucket will be created"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "url-shortener"
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

