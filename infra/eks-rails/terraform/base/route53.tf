resource "aws_route53_zone" "core_zone" {
  name = var.domain

  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_route53_record" "root_cloudfront" {
  name    = var.domain
  type    = "A"
  zone_id = aws_route53_zone.core_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
