resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.private_subnet_ids
   private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.private_subnet_ids
   private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.route_table_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.private_subnet_ids
   private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-logs-endpoint"
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.private_subnet_ids
   private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-sqs-endpoint"
  }
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.private_subnet_ids
   private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-secretsmanager-endpoint"
  }
}