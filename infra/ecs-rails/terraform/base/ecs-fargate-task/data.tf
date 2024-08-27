data "aws_iam_role" "ecs_service" {
  name = "AWSServiceRoleForECS"
}

data "aws_kms_key" "this" {
  key_id = "alias/${var.kms_alias}"
}
