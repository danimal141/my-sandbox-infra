locals {
  # k8s service account namespace
  k8s_sa_ns_aws_load_balancer_controller = "kube-system"
  # k8s service account name
  k8s_sa_name_aws_load_balancer_controller = "aws-load-balancer-controller"
}

module "iam_assumable_role_aws_load_balancer_controller" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "5.41.0"
  create_role  = true
  role_name    = "aws-load-balancer-controller"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    aws_iam_policy.aws_load_balancer_controller.arn,
  ]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${local.k8s_sa_ns_aws_load_balancer_controller}:${local.k8s_sa_name_aws_load_balancer_controller}"
  ]
}

data "http" "iam_policy_for_aws_load_balancer_controller" {
  # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/installation/#configure-iam
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = "aws-load-balancer-controller"
  policy = data.http.iam_policy_for_aws_load_balancer_controller.response_body
}
