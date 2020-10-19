resource "aws_lb" "main" {
  name               = "lb-curai-${var.env}-${var.application}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = {
    Name = "lb-curai-${var.env}-${var.application}"
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
  load_balancer_arn = aws_alb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.firstopinion_certificate.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default backend"
      status_code  = 200
    }
  }
}
*/

resource "aws_lb_target_group" "test" {
  name        = "lb-tg-curai-${var.env}-${var.application}"
  port        = var.port
  protocol    = var.protocol
  target_type = "ip"
  vpc_id      = var.vpc_id
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
    path                = "/index.html"
    unhealthy_threshold = "2"
  }
}