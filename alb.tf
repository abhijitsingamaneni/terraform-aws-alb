resource "aws_lb" "main" {
  name               = "lb-curai-${var.env}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = {
    Name = "alb-curai-${var.env}"
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

/*resource "aws_alb_listener" "frontend" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default backend"
      status_code  = 200
    }
  }
}

# Service-specific ALB target group, with stickiness and health check
resource "aws_alb_target_group" "target_group" {
  for_each = var.services

  name        = "tg-curai-${var.env}-${var.application}"
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = each.value.health_check_path
    unhealthy_threshold = "2"
  }
}

# Service-specific routing rule, based on hostname checks
resource "aws_alb_listener_rule" "routing_rule" {
  for_each = var.services

  listener_arn = aws_alb_listener.frontend.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.host]
    }
  }
}*/
