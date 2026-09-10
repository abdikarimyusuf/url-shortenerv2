module "vpc"{
    source = "./modules/vpc"
    name = "${var.project_name}-${var.environment}"
    cidr_block = var.vpc_cidr_block
    availability_zones = var.availability_zones
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
}

module "security_groups" {
    source = "./modules/security_group"
    name = "${var.project_name}-${var.environment}"
    vpc_id = module.vpc.vpc_id
}

module "vpc_endpoints" {
    source = "./modules/vpc_endpoint"
    name = "${var.project_name}-${var.environment}"
    vpc_id = module.vpc.vpc_id
    private_subnet_ids = module.vpc.private_subnet_ids
    route_table_ids = module.vpc.private_route_table_ids
    security_group_id = module.security_groups.vpc_endpoint_security_group_id
    subnet_ids = module.vpc.private_subnet_ids
}