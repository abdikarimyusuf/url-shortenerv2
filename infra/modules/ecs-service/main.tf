resource "aws_cloudwatch_log_group" "cloudwatch" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.log_retension_in_days

  tags = {
    Name = "/ecs/${var.project_name}-${var.environment}-logs"
  }


}

resource "aws_ecs_task_definition" "task_def" {
  family                   = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image
      essential = true

      cpu    = var.cpu
      memory = var.memory

      portMappings = var.container_port == null ? [] : [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in var.env : {
          name  = key
          value = value
        }
      ]
      secrets = [
        for secret in var.secrets : {
          name      = secret.name
          valueFrom = secret.value_from
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.cloudwatch.name
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = var.project_name
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-${var.environment}-task"
  }
}

resource "aws_ecs_service" "servcie" {
  name            = var.name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.task_def.id

  launch_type   = "FARGATE"
  desired_count = var.desired_count

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  enable_execute_command = var.enable_execute_command

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.securitygroup_id
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn == null ? [] : [var.target_group_arn]
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  depends_on = [aws_cloudwatch_log_group.cloudwatch]

  tags = {
    Name = "${var.project_name}-${var.environment}-service"
  }

}