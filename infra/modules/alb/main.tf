resource "aws_lb" "alb" {
    name = "${var.name}-alb"
    internal = false
    load_balancer_type = "application"

    security_groups = var.security_group_ids
    subnets = var.subnet_ids
    enable_deletion_protection = false
  
}


resource "aws_lb_target_group" "api_tg" {
    name = "${var.name}-api-tg"
    port = var.api_container_port
    protocol = "http"
    target_type = "ip"

    vpc_id = var.vpc_id

    health_check {
      enabled = true
      path = "/healthz"
      protocol = "http"
      port = "traffic-port"
      healthy_threshold = 
    }
  
}