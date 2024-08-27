module "ecs_fargate_task" {
  source = "../ecs-fargate-task"

  # Common
  task_name  = var.service_name
  account_id = var.account_id
  kms_alias  = var.kms_alias

  # Cluster
  cluster_name  = var.cluster_name
  cluster_arn   = var.cluster_arn
  task_role_arn = var.task_role_arn

  # Network
  vpc_id            = var.vpc_id
  cidr_prefix_16bit = var.cidr_prefix_16bit
  private_subnets   = var.private_subnets

  # for tasks like rails db:xx
  sg_ingress_rule = var.port != null ? [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = ["${var.cidr_prefix_16bit}.0.0/16"]
    }
  ] : null

  # Container
  docker_image = var.docker_image
  cpu          = var.cpu
  memory       = var.memory
  environment  = var.environment
  secrets      = var.secrets
  port_mappings = var.port != null ? [
    {
      appProtocol   = "http"
      containerPort = var.port
      hostPort      = var.port
      name          = "${lower(var.service_name)}-${var.port}-tcp"
      protocol      = "tcp"
    }
  ] : null
}

resource "aws_ecs_service" "this" {
  cluster                            = var.cluster_arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = var.desired_count
  health_check_grace_period_seconds  = 0
  enable_ecs_managed_tags            = true
  name                               = var.service_name
  platform_version                   = "LATEST"
  task_definition                    = "${module.ecs_fargate_task.task_family}:${module.ecs_fargate_task.task_revision}"
  wait_for_steady_state              = null
  enable_execute_command             = true

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  load_balancer {
    container_name   = var.service_name
    container_port   = var.port
    target_group_arn = aws_lb_target_group.this.arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
    subnets          = var.private_subnets
  }
}
