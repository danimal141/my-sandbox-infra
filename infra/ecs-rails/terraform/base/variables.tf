# common
variable "github_owner" {
  type        = string
  description = "GitHub Owner Name"
  default     = "danimal141"
}

variable "system_name" {
  type        = string
  description = "System name"
  default     = "ecs-rails"
}

variable "environment" {
  type        = string
  description = "Target AWS environment"
}

# VPC
variable "cidr_prefix_16bit" {
  type        = string
  description = "16bit cidr prefix to specify"
}

# RDS
variable "db_instance_type" {
  type        = string
  description = "DB instance type"
}

variable "db_instance_count" {
  type        = number
  description = "DB instance count"
}

variable "domain" {
  type        = string
  description = "Domain"
}

# lb logs (s3)
variable "alb_prefix" {
  type        = string
  default     = "alb"
  description = <<-EOS
  (Optional)
  prefix for alb logs
  EOS
}

# ECS
variable "backend_image" {
  type        = string
  description = "backend Docker image URI on ECR"
}

variable "account_id" {
  type = string
}

# ECR
variable "ecr_name" {
  type = string
}
