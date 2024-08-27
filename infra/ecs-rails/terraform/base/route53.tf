resource "aws_route53_zone" "core_zone" {
  name = var.domain

  lifecycle {
    prevent_destroy = true
  }
}
