variable "name" {
  type = string
}

variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "api_service_name" {
  description = "api service name"
  type        = string
}

variable "worker_service_name" {
  description = "worker service name"
  type        = string
}

variable "dashboard_service_name" {
  description = "dashboard service name"
  type        = string
}

variable "rds_instance_identifier" {
  description = "rds instance identifier"
  type        = string
}

variable "alb_arn_suffix" {
  description = "load. balancer ARN suffix"
  type        = string
}

variable "api_tg_arn_suffix" {
  description = "api tg ARN suffix"
  type        = string
}

variable "dashboard_tg_arn_suffix" {
  description = "dashboard tg ARN suffix"
  type        = string
}

variable "redis_replication_group_id" {
  description = "redis replication group id"
  type        = string
}