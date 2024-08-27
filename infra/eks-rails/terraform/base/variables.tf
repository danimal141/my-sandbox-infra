# common
variable "system_name" {
  type        = string
  description = "System name"
}

variable "aws_account_id" {
  type = string
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

# Route53
variable "domain" {
  type        = string
  description = "domain name"
}

# ECR
variable "ecr_name" {
  type        = string
  description = "ECR name"
}

# EKS
variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  description = "Additional IAM roles to add to the aws-auth configmap."
  default     = []
}
