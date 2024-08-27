###############################################
# For terraform CI/CD from Github Actions
###############################################
module "iam_github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "v5.41.0"
}

module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "v5.41.0"

  name     = "terraform-github-actions"
  subjects = ["danimal141/my-sandbox-infra:*"]
  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

module "iam_github_oidc_role_for_app" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "v5.41.0"

  name     = "application-cicd-in-github-actions"
  subjects = ["danimal141/my-sandbox-infra:*"]
  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}
