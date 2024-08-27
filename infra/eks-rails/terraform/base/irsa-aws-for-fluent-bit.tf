locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

# fluent bit cloudwatch iam
module "iam_assumable_role_aws_for_fluent_bit" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"
  create_role                   = true
  role_name                     = "aws-for-fluent-bit"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.aws_for_fluent_bit_assume_role_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:aws-for-fluent-bit:aws-for-fluent-bit"]
}

resource "aws_iam_policy" "aws_for_fluent_bit_assume_role_policy" {
  name   = "aws-for-fluent-bit"
  policy = data.aws_iam_policy_document.aws_for_fluent_bit_assume_role_policy_document.json
}

data "aws_iam_policy_document" "aws_for_fluent_bit_assume_role_policy_document" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "aws_for_fluent_bit_assume_role_policy_attachment" {
  count = length(local.role_policy_arns)

  role       = "aws-for-fluent-bit"
  policy_arn = element(local.role_policy_arns, count.index)
}
