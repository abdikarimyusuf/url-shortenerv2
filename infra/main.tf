module "vpc" {
  source              = "./modules/vpc"
  name                = "${var.project_name}-${var.environment}"
  cidr_block          = var.vpc_cidr_block
  availability_zones  = var.availability_zones
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "security_groups" {
  source       = "./modules/security_groups"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "vpc_endpoints" {
  source             = "./modules/vpc_endpoint"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  aws_region         = var.aws_region
  private_subnet_ids = module.vpc.private_subnet_ids
  route_table_ids    = module.vpc.private_route_table_ids
  security_group_ids = [module.security_groups.vpc_endpoint_security_group_id]
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment
  repositories = [
    "api",
    "worker",
    "dashboard"
  ]
}

module "sqs" {
  source       = "./modules/sqs"
  project_name = var.project_name
  environment  = var.environment

}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  db_name            = var.db_name
  db_username        = var.db_username
  security_group_ids = [module.security_groups.rds_security_group_id]
  private_subnet_ids = [module.vpc.private_subnet_ids[0]]
}

module "redis" {
  source             = "./modules/redis"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = [module.vpc.private_subnet_ids[0]]
  security_group_ids = [module.security_groups.redis_security_group_id]
}

module "iam" {
  source         = "./modules/iam"
  project_name   = var.project_name
  environment    = var.environment
  sqs_queue_arn  = module.sqs.queue_arn
  rds_secret_arn = module.rds.master_user_secret_arn

}

module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  project_name = var.project_name
  environment  = var.environment

}
module "dashboard_service" {
  source = "./modules/ecs-service"
  name   = "${var.project_name}-${var.environment}-dashboard"

  cluster_arn             = module.ecs_cluster.cluster_arn
  task_execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn           = module.iam.ecs_dashboard_role_arn
  image                   = module.ecr.repository_url["dashboard"]
  container_port          = 8081
  subnet_ids              = module.vpc.private_subnet_ids

  securitygroup_id = [module.security_groups.ecs_security_group_id]

  env = {
    PORT = "8081"
  }
}
module "api_service" {
  source                  = "./modules/ecs-service"
  name                    = "${var.project_name}-${var.environment}-api"
  cluster_arn             = module.ecs_cluster.cluster_arn
  task_execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn           = module.iam.ecs_api_role_arn
  image                   = module.ecr.repository_url["api"]
  container_port          = 8080
  subnet_ids              = module.vpc.private_subnet_ids
  securitygroup_id        = [module.security_groups.ecs_security_group_id]
  env = {
    PORT = "8080"
  }

}

module "worker_service" {
  source                  = "./modules/ecs-service"
  name                    = "${var.project_name}-${var.environment}-worker"
  cluster_arn             = module.ecs_cluster.cluster_arn
  task_execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn           = module.iam.ecs_worker_role_arn
  image                   = module.ecr.repository_url["worker"]
  subnet_ids              = module.vpc.private_subnet_ids
  securitygroup_id        = [module.security_groups.ecs_security_group_id]
  env = {
    SQS_QUEUE_URL = module.sqs.queue_url
  }

}



