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
  load_balancer_arn = aws_alb.main.id
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

/*resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}*/

resource "aws_lb_target_group" "test" {
  name        = "lb-tg-curai-${var.env}-${var.application}"
  port        = var.port
  protocol    = var.protocol
  target_type = "instance"
  vpc_id      = var.vpc_id
}