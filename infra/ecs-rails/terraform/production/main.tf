locals {
  cidr_prefix_16bit = "10.1"
  environment       = "production"
}

module "base" {
  source = "../base"

  github_owner = var.github_owner
  environment  = local.environment

  # VPC
  cidr_prefix_16bit = local.cidr_prefix_16bit

  # RDS
  db_instance_count = 1
  db_instance_type  = "db.t3.medium"

  # Route53
  domain = "danimal141.com"

  # ECS
  account_id    = data.aws_caller_identity.current.account_id
  ecr_name      = "${var.system_name}-backend"
  backend_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${var.system_name}-backend:main"
}
