provider "aws" {
  region = var.region
}

provider "vault" {
  add_address_to_env    = false
  token_name            = "terraform-root-elasticache-${formatdate("YYYYMMDDhhmmssZZZ", timestamp())}"
  max_lease_ttl_seconds = 3600
  max_retries           = 2
}

module "les_info" {
  source = "git::https://git.bnc.ca/scm/app6157/terraform-module-les-info.git?ref=v1.6.0"
  les    = var.les
  app_id = "6157"
}

locals {
  vault_path = "${module.les_info.base_vault_path}/elasticache-redis/${var.les}/cluster-endpoint"
}

data "vault_generic_secret" "cluster_endpoint" {
  path = local.vault_path
}

module "redis_cluster_record" {
  source = "git::https://git.bnc.ca/scm/APP15201/terraform-aws-route53?ref=v3.0.0"

  create       = true
  zone_id      = null
  zone_name    = var.zone_name
  private_zone = var.private_zone

  name            = var.name
  type            = "CNAME"
  ttl             = 300
  allow_overwrite = true
  records         = [data.vault_generic_secret.cluster_endpoint.data.endpoint]
  set_identifier  = null
  health_check_id = null
}

resource "vault_generic_secret" "cluster_endpoint" {
  depends_on = [module.redis_cluster_record]
  path       = local.vault_path

  // Updating the endpoint address in the vault with the created Route 53 DNS record.
  data_json = <<EOT
{
  "endpoint" : "${module.redis_cluster_record.record_fqdn}",
  "port" : "${data.vault_generic_secret.cluster_endpoint.data.port}"
}
EOT
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.zone_name
  private_zone = var.private_zone
}