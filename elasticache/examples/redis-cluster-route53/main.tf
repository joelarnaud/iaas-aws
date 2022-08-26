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

module "redis_cluster" {
  source = "../../"
  providers = {
    aws        = aws
    aws.dr_aws = aws.dr
  }
  region     = var.region
  les        = var.les
  app_id     = var.app_id
  cluster_id = var.replication_group_id
  node_type  = var.node_type

  security_group_name     = [var.security_group_name]
  num_node_groups         = var.num_node_groups
  replicas_per_node_group = var.replicas_per_node_group

  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit

  region_dr = var.dr_region

  store_redis_arn = var.ssm_parameter_name
  #  replication_group_id = var.replication_group_id

  zone_name    = var.zone_name
  private_zone = var.private_zone
  name         = var.name

  tags = var.tags
}