locals {
  k8s_sa_ns_external_secrets_operator = "external-secrets"
  # to avoid conflicting with externla-secrets-operator
  k8s_sa_name_external_secrets_operator = "for-cluster-secret-store"
}

module "iam_assumable_role_external_secrets_operator" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"
  create_role                   = true
  role_name                     = "external-secrets-operator"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_sa_ns_external_secrets_operator}:${local.k8s_sa_name_external_secrets_operator}"]
}
