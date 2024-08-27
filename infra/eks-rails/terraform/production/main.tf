locals {
  cidr_prefix_16bit = "10.1"
  environment       = "production"
  system_name       = "eks-rails"
}

data "aws_caller_identity" "current" {}
data "external" "get_sso_admin_role" {
  program = ["bash", "./bash/get-sso-admin-role.sh"]
}

module "base" {
  source = "../base"

  system_name = local.system_name

  # VPC
  cidr_prefix_16bit = local.cidr_prefix_16bit

  # RDS
  db_instance_count = 1
  db_instance_type  = "db.t3.medium"

  # Route53
  domain = "danimal141.com"

  # ECR
  ecr_name = "${local.system_name}-${local.environment}"

  # EKS
  eks_cluster_name = local.system_name
  aws_account_id   = data.aws_caller_identity.current.account_id

  # Reference: https://dev.classmethod.jp/articles/empowers-aws-sso-user-to-use-cluster-full-access-role-in-the-eks-cluster-with-terraform/
  map_roles = [
    {
      rolearn  = replace(data.external.get_sso_admin_role.result.Arn, "aws-reserved/sso.amazonaws.com/ap-northeast-1/", "")
      username = "${data.external.get_sso_admin_role.result.RoleName}:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]
}
