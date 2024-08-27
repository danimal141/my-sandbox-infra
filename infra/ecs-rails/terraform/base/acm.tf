module "cert_for_app" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name       = var.domain
  zone_id           = aws_route53_zone.core_zone.id
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain}"]
}
