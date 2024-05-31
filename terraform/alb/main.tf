resource "aws_alb_target_group" "main" {
  name     = var.alb_target_group_name
  port     = var.alb_target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    matcher = "200,301,302"
    path    = "/auth/health"
    interval = 120
    timeout = 30
  }
}

resource "aws_alb" "main" {
  name            = var.alb_name
  subnets         = var.subnet_ids
  security_groups = var.security_groups

  tags = {
    Name = "Terraform ALB"
  }
}

resource "aws_alb_listener" "front_end_tls" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "front_end_path" {
  listener_arn = aws_alb_listener.front_end_tls.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.id
  }

  condition {
    path_pattern {
      values = ["/auth"]
    }
  }
}
