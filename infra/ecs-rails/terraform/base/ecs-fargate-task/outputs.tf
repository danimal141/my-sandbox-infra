output "security_group" {
  value = aws_security_group.this.id
}

output "task_arn" {
  value = aws_ecs_task_definition.this.arn_without_revision
}

output "task_family" {
  value = aws_ecs_task_definition.this.family
}

output "task_revision" {
  value = aws_ecs_task_definition.this.revision
}

output "task_execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}
