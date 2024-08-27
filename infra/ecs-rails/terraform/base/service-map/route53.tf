# for lb
resource "aws_route53_record" "main" {
  name    = var.domain
  type    = "A"
  zone_id = var.core_zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
