variable "region" {
  description = "The target AWS primary region on which to create the main resources."
  type        = string
  nullable    = false

  validation {
    condition = (
      var.region == "ca-central-1" || var.region == "eu-west-1"
    )
    error_message = "The region value must be \"ca-central-1\" or \"eu-west-1\"."
  }
}

variable "region_dr" {
  description = "The target AWS disaster recovery (DR) region on which to create the backup resources."
  type        = string
  nullable    = false

  validation {
    condition = (
      var.region_dr == "ca-central-1" || var.region_dr == "eu-west-1"
    )
    error_message = "The region value must be \"ca-central-1\" or \"eu-west-1\"."
  }
}

variable "vpc_id" {
  description = "The VPC ID of the matched security groups."
  type        = string
  nullable    = false
}

variable "vpc_id_dr" {
  description = "The VPC ID of the matched security groups in the secondary region."
  type        = string
  nullable    = false
}

variable "security_group_ids" {
  description = "The name of the VPC security group to be associated with the cache cluster in the primary region."
  type        = list(string)
  nullable    = false
}

variable "engine" {
  description = "Nme of the cache engine to be used for this cache cluster."
  type        = string
  nullable    = false
}

variable "engine_version" {
  description = "Version number of the cache engine to be used."
  type        = string
  nullable    = false
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with this cache cluster."
  type        = string
  nullable    = false
}

variable "node_type" {
  description = "The instance class to be used. Provides the memory and computational power of the cache nodes."
  type        = string
  nullable    = false
}

variable "num_node_groups" {
  description = <<-EOT
The number of node groups (shards) for the Redis cluster/replication group.
Changing this number will trigger an online resizing operation before other settings modifications.
EOT
  type        = number
  nullable    = true
}

variable "replicas_per_node_group" {
  description = <<-EOT
The number of replica nodes in each node group. Valid values are 0 to 5.
Changing this number will trigger an online resizing operation before other settings modifications.
EOT
  type        = number
  nullable    = false
}

variable "maintenance_window" {
  description = <<-EOT
Specifies the weekly time range for when maintenance on the cache cluster is performed.
The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period.
EOT
  type        = string
  default     = "fri:08:00-fri:09:00"
  nullable    = false
}

variable "snapshot_window" {
  description = <<-EOT
The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of the cache cluster.
The minimum snapshot window is a 60 minute period.
EOT
  type        = string
  default     = "06:30-07:30"
  nullable    = false
}

variable "snapshot_retention_limit" {
  description = <<-EOT
The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them.
For example, if the SnapshotRetentionLimit is set to 5, then a snapshot that was taken today will be retained for 5 days before being deleted.
If the value of snapshot_retention_limit is set to zero (0), backups are turned off.
EOT
  type        = number
  default     = 0
  nullable    = false
}

variable "creation_dr" {
  description = "If create DR in eu-west-1."
  type        = bool
  default     = true
}

variable "security_group_ids_dr" {
  description = "One or more VPC security groups associated with the cache cluster."
  type        = list(string)
  default     = []
}

variable "vault_path" {
  description = "Path of vault to store the token."
  type        = string
  nullable    = false
}

variable "store_redis_arn" {
  description = "The mame of the SSM parameter holding the ARN of the ElastiCache primary cluster/replication group."
  type        = string
  nullable    = false
}

variable "cluster_id" {
  description = "The primary Redis cluster/replication group identifier. This parameter is stored as a lowercase string."
  type        = string
  nullable    = false
}

/*
variable "path" {
  description = "The full logical path at which to write the given data."
  type        = string
  nullable    = false
}
*/

variable "security_group_names" {
  description = "The name of the VPC security group to be associated with the cache cluster in the primary region."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "tag_environment" {
  description = <<-EOT
A tag for the environment in which the resources are being deployed (production or non-production).
Must be specified if the kms_key_id and dr_kms_key_id variables are null in the redis_cluster module.
It will allow the KMS keys' alias to be defined within the redis_cluster module.
EOT
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_application_id" {
  description = <<-EOT
A tag for the application ID. Must be specified if the kms_key_id and dr_kms_key_id variables are null in the redis_cluster module.
It will allow the KMS keys' alias to be defined within the redis_cluster module.
EOT
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_support_group" {
  description = "A tag for the name of the resource's support group."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_email_support" {
  description = "A tag for the email address of the resource's support team."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_account" {
  description = "A tag for the account name."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_asset_owner" {
  description = "A tag for the asset owner name."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_jira_project_key" {
  description = "A tag for the Jira project key name."
  type        = string
  default     = ""
  nullable    = true
}






/*
variable "region" {
  description = "The target AWS primary region on which to create the main resources."
  type        = string
  nullable    = false

  validation {
    condition = (
      var.region == "ca-central-1" || var.region == "eu-west-1"
    )
    error_message = "The region value must be \"ca-central-1\" or \"eu-west-1\"."
  }
}

variable "region_dr" {
  description = "The target AWS disaster recovery (DR) region on which to create the backup resources."
  type        = string
  nullable    = false

  validation {
    condition = (
      var.region_dr == "ca-central-1" || var.region_dr == "eu-west-1"
    )
    error_message = "The region value must be \"ca-central-1\" or \"eu-west-1\"."
  }
}

variable "les" {
  description = "The Logical Environment Specifier (LES). Can be either \"dev\", \"sbx\", \"stg\" or \"prd\"."
  type        = string
  nullable    = false
}

variable "ssm_parameter_name" {
  description = "The mame of the SSM parameter holding the ARN of the ElastiCache primary cluster/replication group."
  type        = string
  nullable    = false
}

variable "security_group_name" {
  description = "The name of the VPC security group to be associated with the cache cluster in the primary region."
  type        = string
  nullable    = false
}

variable "replication_group_id" {
  description = "The primary Redis cluster/replication group identifier. This parameter is stored as a lowercase string."
  type        = string
  nullable    = false
}

variable "node_type" {
  description = "The instance class to be used. Provides the memory and computational power of the cache nodes."
  type        = string
  nullable    = false
}

variable "num_node_groups" {
  description = <<-EOT
The number of node groups (shards) for the Redis cluster/replication group.
Changing this number will trigger an online resizing operation before other settings modifications.
EOT
  type        = number
  nullable    = true
}

variable "replicas_per_node_group" {
  description = <<-EOT
The number of replica nodes in each node group. Valid values are 0 to 5.
Changing this number will trigger an online resizing operation before other settings modifications.
EOT
  type        = number
  nullable    = false
}

variable "maintenance_window" {
  description = <<-EOT
Specifies the weekly time range for when maintenance on the cache cluster is performed.
The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period.
EOT
  type        = string
  default     = "fri:08:00-fri:09:00"
  nullable    = false
}

variable "snapshot_window" {
  description = <<-EOT
The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of the cache cluster.
The minimum snapshot window is a 60 minute period.
EOT
  type        = string
  default     = "06:30-07:30"
  nullable    = false
}

variable "snapshot_retention_limit" {
  description = <<-EOT
The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them.
For example, if the SnapshotRetentionLimit is set to 5, then a snapshot that was taken today will be retained for 5 days before being deleted.
If the value of snapshot_retention_limit is set to zero (0), backups are turned off.
EOT
  type        = number
  default     = 0
  nullable    = false
}

variable "generate_auth_token" {
  description = <<-EOT
A value indicating whether to generate a Redis authentication token if the transit_encryption_enabled variable is true.
The authentication token is used as a password to access the Redis server.
EOT
  type        = bool
  default     = true
  nullable    = false
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "tag_environment" {
  description = <<-EOT
A tag for the environment in which the resources are being deployed (production or non-production).
Must be specified if the kms_key_id and dr_kms_key_id variables are null in the redis_cluster module.
It will allow the KMS keys' alias to be defined within the redis_cluster module.
EOT
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_application_id" {
  description = <<-EOT
A tag for the application ID. Must be specified if the kms_key_id and dr_kms_key_id variables are null in the redis_cluster module.
It will allow the KMS keys' alias to be defined within the redis_cluster module.
EOT
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_support_group" {
  description = "A tag for the name of the resource's support group."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_email_support" {
  description = "A tag for the email address of the resource's support team."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_account" {
  description = "A tag for the account name."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_asset_owner" {
  description = "A tag for the asset owner name."
  type        = string
  default     = ""
  nullable    = true
}

variable "tag_jira_project_key" {
  description = "A tag for the Jira project key name."
  type        = string
  default     = ""
  nullable    = true
}
*/