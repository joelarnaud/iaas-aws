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

variable "application_id" {
  description = "The number that refer to the application ID"
  type        = string
  default     = ""
  nullable    = false
}

variable "security_group_name" {
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

#redis-cluster
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

variable "private_zone" {
  description = "Used with the zone_name variable to get a private hosted zone in Route 53."
  type        = bool
  nullable    = false
  default     = false
}

variable "zone_name" {
  description = "The hosted zone name of the desired hosted (DNS) zone in Route 53."
  type        = string
  nullable    = false
}

variable "name" {
  description = "The name of the Route 53 record to be created. It will be concatenated to the hosted zone name to generate the FQDN."
  type        = string
  nullable    = false
}

variable "ssm_parameter_name" {
  description = "The mame of the SSM parameter holding the ARN of the ElastiCache primary cluster/replication group."
  type        = string
  nullable    = false
}