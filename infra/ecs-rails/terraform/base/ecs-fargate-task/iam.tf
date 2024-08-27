data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  description           = "Task execution role for ${var.cluster_name}:${var.task_name}. Managed by Terraform."
  force_detach_policies = false

  inline_policy {
    name = "ecs-task-execution"
    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "ECR",
            "Effect" : "Allow",
            "Action" : [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability"
            ],
            "Resource" : "*"
          },
          {
            "Sid" : "CreateLogs",
            "Effect" : "Allow",
            "Action" : [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource" : [
              "arn:aws:logs:ap-northeast-1:${var.account_id}:log-group:/ecs/${var.task_name}:log-stream:ecs/${var.task_name}/*",
            ]
          },
          {
            "Sid" : "CreateLogGroup",
            "Effect" : "Allow",
            "Action" : [
              "logs:CreateLogGroup",
            ],
            "Resource" : [
              "arn:aws:logs:ap-northeast-1:${var.account_id}:log-group:/ecs/${var.task_name}:log-stream:"
            ]
          },
          {
            "Sid" : "ReadSsmParameters",
            "Effect" : "Allow",
            "Action" : [
              "kms:Decrypt",
              "ssm:GetParameters"
            ],
            "Resource" : [
              "arn:aws:ssm:ap-northeast-1:${var.account_id}:parameter/*",
              data.aws_kms_key.this.arn
            ]
          }
        ]
      }
    )
  }

  max_session_duration = 3600
  name                 = "${var.cluster_name}_${var.task_name}_ecsTaskExecutionRole"
  name_prefix          = null
  path                 = "/"
  permissions_boundary = null
  tags                 = {}
  tags_all             = {}
}
