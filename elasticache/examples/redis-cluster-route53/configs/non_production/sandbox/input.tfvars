les            = "sbx"
application_id = "7363"

region                   = "ca-central-1"
region_dr                = "eu-west-1"
security_group_name      = "7363-redis-sbx-npr-sgr"
replication_group_id     = "redis-cluster-sbx"
node_type                = "cache.t4g.micro" # Node types R5, R6g, R6gd, M5 or M6g only are supported for a global datastore.
num_node_groups          = 2
replicas_per_node_group  = 2
maintenance_window       = "sun:06:20-sun:08:30" # UTC time corresponds to sun:02:20-sun:04:30 Montreal time.
snapshot_window          = "11:20-13:20"
snapshot_retention_limit = 0

tags = {
  bnc_copyright        = "National Bank of Canada"
  bnc_project_name     = "7363-npr-com"
  bnc_domain           = "TRXBKG"
  bnc_email_support    = "SI-Bancaire-Monitoring@bnc.ca"
  bnc_support_group    = "BNC-APPL-DOM-BANCAIRE"
  bnc_asset_owner      = "soufiane.khouya@bnc.ca"
  bnc_jira_project_key = "DTB"
  bnc_account          = "RUN"
  bnc_environment      = "non-production"
  bnc_application_id   = "7363"
}

zone_name    = "7363.npr.aws.bngf.local"
private_zone = true
name         = "7363-elasticache-redis-sbx"
# Must be defined to allow the module to construct the centralized KMS keys' alias.
#tag_environment    = "non-production"

ssm_parameter_name = "/nonprod/sandbox/redis-cluster/redis-cluster"