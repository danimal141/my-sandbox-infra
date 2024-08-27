module "service-map" {
  source = "./service-map/"

  system_name = var.system_name
  domain      = "ecs.${var.domain}"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # LB
  idle_timeout = 600
  routing_rules = [
    {
      name             = "${var.system_name}-backend"
      priority         = 1
      paths            = ["/*"]
      target_group_arn = module.backend.target_group_arn
    }
  ]

  certificate_arn = module.cert_for_app.acm_certificate_arn
  core_zone_id    = aws_route53_zone.core_zone.zone_id
}
