variable "name" {
  type = string
}

variable "security_group_ids" {
  description = "alb sg"
  type        = list(string)
}

variable "subnet_ids" {
  description = "subnet for the alb"
  type        = list(string)
}
variable "api_container_port" {
  description = "api contianer port "
  type        = number
}
variable "vpc_id" {
  description = "vpc id "
  type        = string
}

variable "dashboard_container_port" {
  description = "dashboard contianer port"
  type        = number
}

variable "certificate_arn" {
  description = "certificate arn for the alb"
  type        = string
}