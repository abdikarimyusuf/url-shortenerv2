variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage for the RDS database in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "The maximum allocated storage for the RDS database in GB"
  type        = number
  default     = 100
}

variable "db_instance_class" {
  description = "The instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "The database engine for the RDS database"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "16"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_port" {
  description = "The port for the database"
  type        = number
  default     = 5432
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the RDS instance"
  type        = list(string)
}

variable "db_backup_retention_period" {
  description = "The number of days to retain backups for the RDS database"
  type        = number
  default     = 2
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}
