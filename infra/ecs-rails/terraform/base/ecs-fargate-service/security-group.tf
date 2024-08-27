resource "aws_security_group" "this" {
  description = "Security group for ECS service ${var.cluster_name}:${var.service_name}. Managed by Terraform."

  egress = [{
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }]

  ingress = [{
    description      = ""
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = ["${var.cidr_prefix_16bit}.0.0/16"]
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }]

  name                   = "${var.cluster_name}-${var.service_name}-ecs-service"
  vpc_id                 = var.vpc_id
  name_prefix            = null
  revoke_rules_on_delete = null
}
