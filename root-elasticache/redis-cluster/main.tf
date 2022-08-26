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

data "aws_security_groups" "redis_security_groups" {
  filter {
    name   = "group-name"
    values = [var.security_group_name]
  }
}

module "les_info" {
  source = "git::https://git.bnc.ca/scm/app6157/terraform-module-les-info.git?ref=v1.6.0"
  les    = var.les
  app_id = "6157"
}

locals {
  vault_path = "${module.les_info.base_vault_path}/elasticache-redis/${var.les}"
}

module "redis_cluster" {
  source = "git::https://git.bnc.ca/scm/APP15201/terraform-aws-elasticache-cluster.git?ref=v5.0.1"
  providers = {
    aws        = aws
    aws.dr_aws = aws.dr
  }

  region = var.region

  vpc_id               = module.les_info.vpc_id
  security_group_ids   = data.aws_security_groups.redis_security_groups.ids
  security_group_names = []

  create_elasticache_subnet_group = true
  elasticache_subnet_group_name   = "" # The cache subnet group will be created within the module.

  cluster_id           = var.replication_group_id
  engine               = "redis"
  engine_version       = "6.x"
  parameter_group_name = "default.redis6.x.cluster.on"
  redis_parameters     = [] # To add any parameter into the custom ElastiCache parameter group created within the module.
  node_type            = var.node_type
  port                 = 6379 # Default port for Redis

  num_node_groups         = var.num_node_groups
  num_cache_nodes         = null # Not used with Redis cluster mode
  number_cache_clusters   = null # Must be null to enable the cluster mode within the module.
  replicas_per_node_group = var.replicas_per_node_group

  multi_az_enabled               = true
  redis_failover                 = true # Does not need to be specified if the multi_az_enabled variable is set to true.
  apply_immediately              = true
  auto_minor_version_upgrade     = true
  redis_maintenance_window       = var.maintenance_window
  redis_snapshot_window          = var.snapshot_window
  redis_snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_arns                  = []
  snapshot_name                  = null
  notification_topic_arn         = null

  at_rest_encryption_enabled = true
  kms_key_id                 = null # The KMS key alias will be defined within the module.
  transit_encryption_enabled = true
  auth_token                 = null # Will be created within the module.
  password_length            = 128
  password_override_special  = "!&#$^<>-"
  password_special_char      = true
  generate_redis_token       = true
  vault_path                 = "${local.vault_path}/auth-token"

  dr_creation           = false
  dr_region             = var.region_dr
  dr_vpc_id             = module.les_info.dr_vpc_id
  dr_security_group_ids = []
  dr_kms_key_id         = null

  tags              = var.tags
  tag_environment   = var.tag_environment
  tag_applicationid = var.tag_application_id
  tag_support       = var.tag_support_group
  tag_email_support = var.tag_email_support
  tag_account       = var.tag_account
  tag_owner         = var.tag_asset_owner
  tag_projectjira   = var.tag_jira_project_key
}

resource "aws_ssm_parameter" "redis_arn" {
  name        = var.ssm_parameter_name
  description = "The ARN of the ElastiCache primary replication group."
  type        = "String"
  value       = module.redis_cluster.arn
  tags        = var.tags
}

data "aws_elasticache_replication_group" "redis_cluster" {
  depends_on           = [module.redis_cluster]
  replication_group_id = var.replication_group_id
}

resource "vault_generic_secret" "cluster_endpoint" {
  path = "${local.vault_path}/cluster-endpoint"

  // Using the configuration endpoint address since the cluster mode is enabled on the cluster.
  data_json = <<EOT
{
  "endpoint" : "${data.aws_elasticache_replication_group.redis_cluster.configuration_endpoint_address}",
  "port" : "${data.aws_elasticache_replication_group.redis_cluster.port}"
}
EOT
}