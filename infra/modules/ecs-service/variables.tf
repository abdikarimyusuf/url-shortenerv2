
variable "name" {
  description = "name of the service"
  type        = string

}

variable "log_retension_in_days" {
  description = "logs retension in days"
  type        = number
  default     = 7

}



variable "cpu" {
  description = "CPU units for the Fargate task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MiB for the Fargate task"
  type        = number
  default     = 512

}

variable "task_execution_role_arn" {
  description = "task execusion role "
  type        = string

}

variable "task_role_arn" {
  description = "container role"
  type        = string

}
variable "image" {
  description = "container image"
  type        = string

}

variable "container_port" {
  description = "container port"
  type        = number
  default     = null
}

variable "env" {
  description = "Environment variables passed into the container"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "injected secrets"
  type = list(object({

  }))

  default = []

}


variable "cluster_arn" {
  description = "cluster arn"
  type        = string

}

variable "desired_count" {
  description = "service desired count"
  type        = number
  default     = 1
}

variable "enable_execute_command" {
  description = "enables shell on container"
  type        = bool
  default     = true

}

variable "subnet_ids" {
  description = "the subnet id "
  type        = list(string)

}
variable "securitygroup_id" {
  description = "sg for the tasks"
  type        = list(string)

}

variable "assign_public_ip" {
  description = "attach public ip on start up"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "target group for the loan balance"
  type        = string
  default     = null
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "url-shortener"
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}