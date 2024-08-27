locals {
  # k8s service account namespace
  k8s_sa_ns_external_dns = "external-dns"
  # k8s service account name
  k8s_sa_name_external_dns = "external-dns"
}

module "iam_assumable_role_external_dns" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"
  create_role                   = true
  role_name                     = "external-dns"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_sa_ns_external_dns}:${local.k8s_sa_name_external_dns}"]
}

resource "aws_iam_policy" "external_dns" {
  name = "external-dns"

  # https://github.com/kubernetes-sigs/external-dns/blob/d0c776b0/docs/tutorials/aws.md#iam-policy
  policy = <<-EOF
  {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": [
         "route53:ChangeResourceRecordSets"
       ],
       "Resource": [
         "arn:aws:route53:::hostedzone/*"
       ]
     },
     {
       "Effect": "Allow",
       "Action": [
         "route53:ListHostedZones",
         "route53:ListResourceRecordSets"
       ],
       "Resource": [
         "*"
       ]
     }
   ]
  }
  EOF
}
