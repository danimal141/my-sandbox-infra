locals {
  common_environments = [
    {
      name  = "DATABASE_NAME"
      value = "ecs_rails"
    },
    {
      name  = "RAILS_ENV"
      value = "production"
    },
  ]
  common_secrets = [
    {
      name      = "DATABASE_USER"
      valueFrom = "/${var.system_name}/rds/master-username"
    },
    {
      name      = "DATABASE_HOST"
      valueFrom = "/${var.system_name}/rds/endpoint"
    },
    {
      name      = "DATABASE_PORT"
      valueFrom = "/${var.system_name}/rds/port"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "/${var.system_name}/rds/master-password"
    },
  ]
}

resource "aws_ecs_cluster" "this" {
  name = var.system_name
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.this.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}

resource "aws_service_discovery_http_namespace" "this" {
  name = var.system_name
}

resource "aws_scheduler_schedule_group" "this" {
  name = var.system_name
}

resource "aws_iam_role" "task_role" {
  name = "${var.system_name}_ecsTaskRole"

  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = []
  inline_policy {
    name = "ecs-execute-command"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SSM",
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}

module "backend" {
  source = "./ecs-fargate-service"

  service_name = "${var.system_name}-backend"
  account_id   = var.account_id
  kms_alias    = var.system_name

  cluster_name  = aws_ecs_cluster.this.name
  cluster_arn   = aws_ecs_cluster.this.arn
  task_role_arn = aws_iam_role.task_role.arn
  desired_count = 2

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  cidr_prefix_16bit = var.cidr_prefix_16bit
  docker_image      = var.backend_image
  cpu               = 512
  memory            = 1024
  port              = 3000
  environment       = local.common_environments
  secrets           = local.common_secrets
  health_check_path = "/heartbeat"
}

module "db-migrate" {
  source = "./ecs-fargate-task"

  task_name  = "db-migrate"
  account_id = var.account_id
  kms_alias  = var.system_name

  cluster_name  = aws_ecs_cluster.this.name
  cluster_arn   = aws_ecs_cluster.this.arn
  task_role_arn = aws_iam_role.task_role.arn

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  cidr_prefix_16bit = var.cidr_prefix_16bit

  docker_image = var.backend_image
  cpu          = 512
  memory       = 1024
  environment  = local.common_environments
  secrets      = local.common_secrets
  command      = ["bash", "-c", "bin/rails db:migrate"]
}
