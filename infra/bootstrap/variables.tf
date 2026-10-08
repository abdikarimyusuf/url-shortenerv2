variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "url-shortener-bucket-1234567890123"
}

variable "region" {
  description = "The AWS region where the S3 bucket will be created"
  type        = string
  default     = "eu-west-2"
}

variable "name" {
  description = "The name of the project"
  type        = string
  default     = "url-shortener"
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "github_repository" {
  description = "github repo"
  type        = string
  default     = "abdikarimyusuf/url-shortenerv2"
}

variable "github_branch" {
  description = "github branch"
  type        = string
  default     = "main"
}


