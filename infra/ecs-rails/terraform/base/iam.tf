###############################################
# For terraform CI/CD from Github Actions
###############################################
module "iam_github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "v5.41.0"

  tags = {
    Environment = var.environment
  }
}

module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "v5.41.0"

  name     = "terraform-github-actions"
  subjects = ["${var.github_owner}/my-sandbox-infra:*"]
  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  tags = {
    Environment = var.environment
  }
}

module "iam_github_oidc_role2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "v5.41.0"

  name     = "application-cicd-in-github-actions"
  subjects = ["${var.github_owner}/my-sandbox-infra:*"]
  policies = {
    ECSAccess                           = aws_iam_policy.ecs_service_update_for_app.arn
    AmazonEC2ContainerRegistryPowerUser = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    AmazonSSMReadOnlyAccess             = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  }

  tags = {
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_service_update_for_app" {
  name = "ecs_service_update"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:ecs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:service/${var.system_name}/*",
          "arn:aws:ecs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:task-definition/db-migrate:*",
          "arn:aws:ecs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:task/${var.system_name}/*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.system_name}_db-migrate_ecsTaskExecutionRole"
        ]
      }
    ]
  })
}
