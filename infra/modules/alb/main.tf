resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

}


resource "aws_lb_target_group" "api_tg" {
  name        = "${var.name}-api-tg"
  port        = var.api_container_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    path                = "/healthz"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"

  }
  deregistration_delay = 30

  tags = {
    Name = "${var.name}-api-tg"
  }
}

resource "aws_lb_target_group" "db_tg" {
  name        = "${var.name}-db-tg"
  port        = var.dashboard_container_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    path                = "/healthz"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
  deregistration_delay = 30

  tags = {
    name = "${var.name}-dashboard-tg"
  }

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${var.name}-http-listener"
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn
  depends_on = [
  var.certificate_arn]
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
  tags = {
    Name = "${var.name}-https-listener"
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.id
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }

  condition {
    path_pattern {
      values = [
        "/api/*"
      ]
    }
  }


}


resource "aws_lb_listener_rule" "redirect_api" {
  listener_arn = aws_lb_listener.https.id
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }

  condition {
    path_pattern {
      values = [
        "/i/*"
      ]
    }
  }


}


resource "aws_lb_listener_rule" "dashboard" {
  listener_arn = aws_lb_listener.http.id
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.db_tg.arn
  }
  condition {
    path_pattern {
      values = [
        "/dashboard/*"
      ]
    }
  }
}
