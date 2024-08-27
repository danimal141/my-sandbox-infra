module "cert_for_app" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name       = var.domain
  zone_id           = aws_route53_zone.core_zone.id
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain}"]
}

module "cert_for_argo_cd" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name       = "argocd.${var.domain}"
  zone_id           = aws_route53_zone.core_zone.id
  validation_method = "DNS"
}

module "cert_for_cloudfront" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name       = var.domain
  zone_id           = aws_route53_zone.core_zone.id
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}",
  ]

  providers = {
    # for cloudfront
    aws = aws.us_east_1
  }
}
