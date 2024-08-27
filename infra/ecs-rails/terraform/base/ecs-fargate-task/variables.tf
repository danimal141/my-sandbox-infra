# Common
variable "task_name" {
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

variable "port_mappings" {
  type = list(object({
    appProtocol   = string
    containerPort = number
    hostPort      = number
    name          = string
    protocol      = string
  }))
  default = null
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

variable "command" {
  type    = list(string)
  default = null
}

variable "task_role_arn" {
  type        = string
  description = "IAM role ARN to use AWS services from containers"
}

variable "sg_ingress_rule" {
  type = list(object({
    description      = optional(string, "")
    from_port        = number       # 80
    to_port          = number       # 1000
    protocol         = string       # "tcp"
    cidr_blocks      = list(string) #["10.0.0.0/16"]
    self             = optional(bool, false)
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
  }))
  default     = null
  description = <<-EOS
    [{
      from_port        = var.port
      to_port          = var.port
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"]
    }]
  EOS
}
