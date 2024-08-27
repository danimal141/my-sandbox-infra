# Common
variable "system_name" {
  type        = string
  description = "System name"
  default     = "my-sandbox-infra-ecs-rails"
}

variable "domain" {
  type        = string
  description = "Domain"
}

# VPC
variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

# Route53
variable "core_zone_id" {
  type = string
}

# lb
variable "idle_timeout" {
  type        = string
  description = "idle timeout"
}

variable "certificate_arn" {
  type = string
}

variable "routing_rules" {
  type = list(object({
    name             = string
    priority         = number
    paths            = optional(list(string), [])
    host_headers     = optional(list(string), [])
    target_group_arn = string
  }))
  description = "Routing rules with explicit priorities"
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

