/*
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "dr"
  region = var.region_dr
}

provider "vault" {
  add_address_to_env    = false
  token_name            = "terraform-root-elasticache-${formatdate("YYYYMMDDhhmmssZZZ", timestamp())}"
  max_lease_ttl_seconds = 3600
  max_retries           = 2
}
*/
data "aws_security_groups" "redis_security_groups" {
  filter {
    name   = "group-name"
    values = [var.security_group_name]
  }
}

module "les_info" {
  source = "git::https://git.bnc.ca/scm/app7363/terraform-module-les-info.git?ref=v1.0.1"
  les    = var.les
  app_id = var.application_id # "6157"
}

locals {
  vault_path = "${module.les_info.base_vault_path}/elasticache-redis/${var.les}"
}


module "elasticache_redis" {
  source = "./modules/redis-cluster"
  providers = {
    aws        = aws
    aws.dr_aws = aws.dr
  }
  region = var.region

  vpc_id               = module.les_info.vpc_id
  security_group_ids   = data.aws_security_groups.redis_security_groups.ids
  security_group_names = []

  cluster_id           = var.cluster_id
  engine               = "redis"
  engine_version       = "6.x"
  parameter_group_name = "default.redis6.x.cluster.on"
  # redis_parameters     = [] # To add any parameter into the custom ElastiCache parameter group created within the module.
  node_type = var.node_type
  # port                 = 6379 # Default port for Redis

  num_node_groups         = var.num_node_groups
  replicas_per_node_group = var.replicas_per_node_group

  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit

  vault_path = "${local.vault_path}/auth-token"

  creation_dr           = false
  region_dr             = var.region_dr
  vpc_id_dr             = module.les_info.vpc_id_dr
  security_group_ids_dr = []

  store_redis_arn = var.ssm_parameter_name
  #  replication_group_id = var.replication_group_id
  #  path                 = "${local.vault_path}/cluster-endpoint"

  tags = var.tags
}

module "route53_record" {
  source               = "./modules/route53"
  region               = var.region
  zone_name            = var.zone_name
  private_zone         = var.private_zone
  name                 = var.name
  replication_group_id = var.replication_group_id
  #  path         = "${local.vault_path}/cluster-endpoint"
}