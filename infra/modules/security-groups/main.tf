resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-vpc-endpoint-sg"
  description = "Security group for alb"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "aws_vpc_securuty_group_ingress_rule" "alb_http" {
    security_group_id = aws_security_group.alb.id

    cidr_ipv4 ="0.0.0.0/0"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    discription = "Allow HTTP traffic from the internet"
}

resource "aws_vpc_securuty_group_ingress_rule" "alb_https" {
    security_group_id = aws_security_group.alb.id

    cidr_ipv4 ="0.0.0.0/0"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    discription = "Allow HTTPS traffic from the internet"
}   

resource "aws_vpc_securuty_group_egress_rule" "alb_egress" {
    security_group_id = aws_security_group.alb.id

    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol = "-1" #all protocols
    description = "Allow all outbound traffic from the alb"
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Security group for ecs"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-ecs-sg"
  }
}

resource "aws_vpc_securuty_group_ingress_rule" "ecs_api" {
    security_group_id = aws_security_group.ecs.id

    referenced_security_group_id = aws_security_group.alb.id
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    discription = "Allow HTTPS traffic from the alb"
}

resource "aws_vpc_securuty_group_ingress_rule" "ecs_dashboard" {
    security_group_id = aws_security_group.ecs.id

    referenced_security_group_id = aws_security_group.alb.id
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    discription = "Allow HTTPS traffic from the alb"
}




resource "aws_vpc_securuty_group_egress_rule" "ecs_egress" {
    security_group_id = aws_security_group.ecs.id

    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol = "-1" #all protocols
    description = "Allow all outbound traffic from the ecs"
}


resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for rds"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

resource "aws_vpc_securuty_group_ingress_rule" "rds_postgres" {
    security_group_id = aws_security_group.rds.id

    referenced_security_group_id = aws_security_group.ecs.id
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    discription = "Allow Postgres traffic from the ecs"
}

resource "aws_vpc_securuty_group_egress_rule" "rds_egress" {
    security_group_id = aws_security_group.rds.id

    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol = "-1" #all protocols
    description = "Allow outbound traffic from the rds"
}

resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-redis-sg"
  description = "Security group for redis"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-redis-sg"
  }
}

resource "aws_vpc_securuty_group_ingress_rule" "redis" {
    security_group_id = aws_security_group.redis.id

    referenced_security_group_id = aws_security_group.ecs.id
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    discription = "Allow Redis traffic from the ecs"
}

resource "aws_vpc_securuty_group_egress_rule" "redis_egress" {
    security_group_id = aws_security_group.redis.id

    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol = "-1" #all protocols
    description = "Allow all outbound traffic from the redis"
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project_name}-${var.environment}-vpc-endpoint-sg"
  description = "Security group for vpc endpoint"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-vpc-endpoint-sg"
  }
}

resource "aws_vpc_securuty_group_ingress_rule" "vpc_endpoint" {
    security_group_id = aws_security_group.vpc_endpoint.id

    referenced_security_group_id = aws_security_group.ecs.id
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    discription = "Allow HTTPS traffic from the ecs"
}

resource "aws_vpc_securuty_group_egress_rule" "vpc_endpoint_egress" {
    security_group_id = aws_security_group.vpc_endpoint.id

    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol = "-1" #all protocols
    description = "Allow all outbound traffic from the vpc_endpoint"
}
