# Common
variable "service_name" {
  type = string
}

variable "account_id" {
  type = string
}

variable "kms_alias" {
  type = string
}

# Cluster
variable "cluster_name" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "desired_count" {
  type = number
}

# Network
variable "vpc_id" {
  type = string
}

variable "cidr_prefix_16bit" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

# Container
variable "docker_image" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "port" {
  type = number
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "health_check_path" {
  type = string
}

variable "task_role_arn" {
  type        = string
  description = "IAM role ARN to use AWS services from containers"
}
