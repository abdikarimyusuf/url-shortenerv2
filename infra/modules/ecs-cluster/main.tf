resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-cluster"
  }

}