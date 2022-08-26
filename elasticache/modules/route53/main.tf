provider "aws" {
  region = var.region
}
module "redis_cluster_record" {
  source       = "git::https://git.bnc.ca/scm/APP15201/terraform-aws-route53?ref=v3.0.1"
  region       = var.region
  create       = true
  zone_id      = null
  zone_name    = var.zone_name
  private_zone = var.private_zone

  name            = var.name
  type            = "CNAME"
  ttl             = 300
  allow_overwrite = true
  records         = [data.aws_elasticache_replication_group.redis_cluster.data.configuration_endpoint_address]
  set_identifier  = null
  health_check_id = null
}

data "aws_elasticache_replication_group" "redis_cluster" {
  #  depends_on           = [module.redis_cluster]
  replication_group_id = var.replication_group_id
}

/*
resource "vault_generic_secret" "cluster_endpoint" {
  depends_on = [module.redis_cluster_record]
  path       = var.path # "${local.vault_path}/cluster-endpoint"

  // Updating the endpoint address in the vault with the created Route 53 DNS record.
  data_json = <<EOT
{
  "endpoint" : "${module.redis_cluster_record.record_fqdn}",
  "port" : "${data.vault_generic_secret.cluster_endpoint.data.port}"
}
EOT
}
*/

data "aws_route53_zone" "hosted_zone" {
  name         = var.zone_name
  private_zone = var.private_zone
}
/*
data "vault_generic_secret" "cluster_endpoint" {
  path = var.path # "${local.vault_path}/cluster-endpoint"
}
*/