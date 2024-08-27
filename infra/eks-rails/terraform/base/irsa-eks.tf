locals {
  # k8s service account namespace
  k8s_sa_ns_app = var.eks_cluster_name
  # k8s service account name
  k8s_sa_name_app = var.eks_cluster_name
}

module "iam_assumable_role_app" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"
  create_role                   = true
  role_name                     = var.eks_cluster_name
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_sa_ns_app}:${local.k8s_sa_name_app}"]
}
