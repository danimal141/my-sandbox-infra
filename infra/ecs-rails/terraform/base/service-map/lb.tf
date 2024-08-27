resource "aws_lb" "this" {
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "ipv4"
  load_balancer_type               = "application"
  name                             = var.system_name
  security_groups                  = [aws_security_group.this.id]
  subnets                          = var.public_subnets
  idle_timeout                     = var.idle_timeout

  access_logs {
    bucket  = aws_s3_bucket.log_bucket.id
    prefix  = var.alb_prefix
    enabled = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = { for idx, var_rule in var.routing_rules : var_rule.name => {
    priority         = var_rule.priority
    paths            = var_rule.paths
    host_headers     = var_rule.host_headers
    target_group_arn = var_rule.target_group_arn
  } }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    target_group_arn = each.value.target_group_arn
    type             = "forward"
  }

  dynamic "condition" {
    for_each = length(each.value.paths) > 0 ? [1] : []
    content {
      path_pattern {
        values = each.value.paths
      }
    }
  }

  dynamic "condition" {
    for_each = length(each.value.host_headers) > 0 ? [1] : []
    content {
      host_header {
        values = each.value.host_headers
      }
    }
  }
}
