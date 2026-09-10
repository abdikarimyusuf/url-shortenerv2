variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string    
    default     = "eu-west-2"
  
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

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/24"
}

variable "availability_zones" {
    description = "List of availability zones for the subnets"
    type        = list(string)
    default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidr" {
    description = "List of CIDR blocks for public subnets"
    type        = list(string)
    default     = ["10.0.1.0/27","10.0.2.0/27"]
}

variable "private_subnet_cidr" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
    default     = ["10.0.3.0/27","10.0.4.0/27"]
}