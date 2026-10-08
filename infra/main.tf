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
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "redis" {
  source             = "./modules/redis"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = [module.vpc.private_subnet_ids[0]]
  security_group_ids = [module.security_groups.redis_security_group_id]
}

module "iam" {
  source        = "./modules/iam"
  project_name  = var.project_name
  environment   = var.environment
  sqs_queue_arn = module.sqs.queue_arn
  database_secret_arn    = module.rds.master_user_secret_arn
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
  image                   = "${module.ecr.repository_url["dashboard"]}:latest"
  container_port          = 8081
  container_name          = "dashboard"
  subnet_ids              = module.vpc.private_subnet_ids
  target_group_arn        = module.alb.dashboard_tg_arn

  securitygroup_id = [module.security_groups.ecs_security_group_id]

  env = {
    PORT        = "8081"
    DB_NAME     = var.db_name
    DB_USER     = var.db_username
    DB_PORT     = module.rds.db_instance_port
    DB_HOST     = module.rds.db_endpoint

  }
  secrets = [{
    name       = "DB_PASSWORD"
    value_from = "${module.rds.master_user_secret_arn}:password::"
  }]
}
module "api_service" {
  source                  = "./modules/ecs-service"
  name                    = "${var.project_name}-${var.environment}-api"
  cluster_arn             = module.ecs_cluster.cluster_arn
  task_execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn           = module.iam.ecs_api_role_arn
  image                   = "${module.ecr.repository_url["api"]}:latest"
  container_port          = 8080
  container_name          = "api"
  subnet_ids              = module.vpc.private_subnet_ids
  securitygroup_id        = [module.security_groups.ecs_security_group_id]
  target_group_arn        = module.alb.api_tg_arn
  env = {
    PORT        = "8080"
    DB_NAME     = var.db_name
    DB_USER     = var.db_username
    DB_PORT     = module.rds.db_instance_port
    DB_HOST     = module.rds.db_endpoint
    REDIS_HOST   = module.redis.redis_primary_endpoint
    REDIS_PORT   = 6379
    REDIS_SSL = "true"
    BASE_URL = "https://abdikarim.co.uk"


  }
  secrets = [{
    name       = "DB_PASSWORD"
    value_from = "${module.rds.master_user_secret_arn}:password::"
  }]
  
}



module "worker_service" {
  source                  = "./modules/ecs-service"
  name                    = "${var.project_name}-${var.environment}-worker"
  cluster_arn             = module.ecs_cluster.cluster_arn
  task_execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn           = module.iam.ecs_worker_role_arn
  container_name          = "worker"
  image                   = "${module.ecr.repository_url["worker"]}:latest"
  subnet_ids              = module.vpc.private_subnet_ids
  securitygroup_id        = [module.security_groups.ecs_security_group_id]
  env = {
    HEALTH_PORT   = "8090"
    DB_NAME       = var.db_name
    DB_USER       = var.db_username
    DB_PORT       = module.rds.db_instance_port
    DB_HOST       = module.rds.db_endpoint
    SQS_QUEUE_URL = module.sqs.queue_url
  }
  secrets = [{
    name       = "DB_PASSWORD"
   value_from = "${module.rds.master_user_secret_arn}:password::"
  }]

}

module "alb" {
  source                   = "./modules/alb"
  name                     = "${var.project_name}-${var.environment}-alb"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnet_ids
  security_group_ids       = [module.security_groups.alb_security_group_id]
  api_container_port       = 8080
  dashboard_container_port = 8081
  certificate_arn          = module.dns.alb_certificate_arn
}

module "dns" {
  source                 = "./modules/dns"
  domain_name            = var.domain_name
  subdomain               = var.subdomain
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_zone_id     = module.cloudfront.cloudfront_zone_id
  alb_dns_name           = module.alb.load_balancer_dns_name
  alb_zone_id            = module.alb.load_balancer_zone_id
  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

}

module "waf" {
  source  = "./modules/waf"
  name    = "${var.project_name}-${var.environment}-waf"
  alb_arn = module.alb.load_balancer_arn

}

module "observability" {
  source                     = "./modules/observability"
  name                       = "${var.project_name}-${var.environment}-cloudwatch"
  cluster_name               = module.ecs_cluster.cluster_name
  api_service_name           = module.api_service.service_name
  worker_service_name        = module.worker_service.service_name
  dashboard_service_name     = module.dashboard_service.service_name
  alb_arn_suffix             = module.alb.load_balancer_arn_suffix
  api_tg_arn_suffix          = module.alb.api_tg_arn_suffix
  dashboard_tg_arn_suffix    = module.alb.dashboard_tg_arn_suffix
  rds_instance_identifier    = module.rds.db_instance_id
  redis_replication_group_id = module.redis.redis_id

}


module "cloudfront" {
  source                     = "./modules/frontend"
  bucket_name                = "${var.project_name}-frontend98"
  price_class                = "PriceClass_100"
  origin_name                = "api.abdikarim.co.uk"
  cloudfront_certificate_arn = module.dns.cloudfront_certificate_arn
  domain_name                = var.domain_name

}


