resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode(
    [
      {
        name              = var.task_name
        image             = var.docker_image
        cpu               = var.cpu
        memoryReservation = var.memory
        portMappings      = var.port_mappings
        essential         = true
        command           = var.command
        environment       = var.environment
        secrets           = var.secrets
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "/ecs/${var.task_name}"
            awslogs-region        = "ap-northeast-1"
            awslogs-stream-prefix = "ecs"
          }
          secretOptions = []
        }
      }
    ]
  )

  family                   = var.task_name
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}
