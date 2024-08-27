resource "aws_security_group" "this" {
  description = "Security group for ECS service ${var.cluster_name}:${var.task_name}. Managed by Terraform."

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
  ingress                = var.sg_ingress_rule
  name                   = "${var.cluster_name}-${var.task_name}-ecs-task"
  vpc_id                 = var.vpc_id
  name_prefix            = null
  revoke_rules_on_delete = null
}
