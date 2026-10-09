resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}


resource "aws_db_instance" "db_instance" {
  identifier            = "${var.project_name}-${var.environment}-db-instance"
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = true
  storage_type          = "gp2"
  kms_key_id        = "arn:aws:kms:eu-west-2:266380778025:key/0b4b1abd-5d98-4923-a42a-a27677c753cc"

  engine         = var.db_engine
  engine_version = var.db_engine_version

  instance_class              = var.db_instance_class
  db_name                     = var.db_name
  username                    = var.db_username
  port                        = var.db_port
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot    = true
  master_user_secret_kms_key_id = "arn:aws:kms:eu-west-2:266380778025:key/74bda178-4891-44f4-9506-fd3e7037b940"

  publicly_accessible             = false
  backup_retention_period         = var.db_backup_retention_period
  backup_window                   = "03:00-04:00"
  maintenance_window              = "Mon:04:00-Mon:05:00"
  apply_immediately               = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  performance_insights_enabled    = false
  deletion_protection             = false






  tags = {
    Name = "${var.project_name}-${var.environment}-db-instance"
  }
}