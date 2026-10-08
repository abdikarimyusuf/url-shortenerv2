variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "redis_node_type" {
  description = "The node type for the Redis instance"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_engine_version" {
  description = "The version of the Redis engine"
  type        = string
  default     = "7.0"
}

variable "redis_port" {
  description = "The port for the Redis instance"
  type        = number
  default     = 6379
}

variable "security_group_ids" {
  description = "security_group for redis"
  type        = list(string)

}

variable "private_subnet_ids" {
  description = "security_group for redis"
  type        = list(string)
}