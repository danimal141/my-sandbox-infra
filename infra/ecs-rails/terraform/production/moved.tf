moved {
  from = module.iam_github_oidc_provider.aws_iam_openid_connect_provider.this[0]
  to   = module.base.module.iam_github_oidc_provider.aws_iam_openid_connect_provider.this[0]
}

moved {
  from = module.iam_github_oidc_provider.data.aws_partition.current
  to   = module.base.module.iam_github_oidc_provider.data.aws_partition.current
}

moved {
  from = module.iam_github_oidc_provider.data.tls_certificate.this[0]
  to   = module.base.module.iam_github_oidc_provider.data.tls_certificate.this[0]
}

moved {
  from = module.iam_github_oidc_provider.aws_iam_openid_connect_provider.this[0]
  to   = module.base.module.iam_github_oidc_provider.aws_iam_openid_connect_provider.this[0]
}

moved {
  from = module.iam_github_oidc_role.data.aws_caller_identity.current
  to   = module.base.module.iam_github_oidc_role.data.aws_caller_identity.current
}

moved {
  from = module.iam_github_oidc_role.data.aws_iam_policy_document.this[0]
  to   = module.base.module.iam_github_oidc_role.data.aws_iam_policy_document.this[0]
}

moved {
  from = module.iam_github_oidc_role.data.aws_partition.current
  to   = module.base.module.iam_github_oidc_role.data.aws_partition.current
}

moved {
  from = module.iam_github_oidc_role.aws_iam_role.this[0]
  to   = module.base.module.iam_github_oidc_role.aws_iam_role.this[0]
}

moved {
  from = module.iam_github_oidc_role.aws_iam_role_policy_attachment.this["AdministratorAccess"]
  to   = module.base.module.iam_github_oidc_role.aws_iam_role_policy_attachment.this["AdministratorAccess"]
}
