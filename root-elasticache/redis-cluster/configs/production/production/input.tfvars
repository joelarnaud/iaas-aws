les = "prd"

region                   = "ca-central-1"
region_dr                = "eu-west-1"
security_group_name      = "6157-redis-prd-sgr"
replication_group_id     = "redis-cluster-prd"
node_type                = "cache.t4g.small" # Node types R5, R6g, R6gd, M5 or M6g only are supported for a global datastore.
num_node_groups          = 3
replicas_per_node_group  = 2
maintenance_window       = "sun:06:20-sun:08:30" # UTC time corresponds to sun:02:20-sun:04:30 Montreal time.
snapshot_window          = "11:20-13:20"
snapshot_retention_limit = 0

tags = {
  copyright        = "National Bank of Canada"
  project_name     = "6157-npr-prd"
  tags_source      = "TRXBKG"
  email_support    = "SI-Bancaire-Monitoring@bnc.ca"
  support_group    = "BNC-APPL-DOM-BANCAIRE"
  asset_owner      = "david.lheureux@bnc.ca"
  jira_project_key = "MBQ"
  account          = "RUN"
  environment      = "production"
  application_id   = "6157"
}

# Must be defined to allow the module to construct the centralized KMS keys' alias.
tag_environment    = "production"
tag_application_id = "6157"

ssm_parameter_name = "/production/common/redis-cluster/redis-cluster"