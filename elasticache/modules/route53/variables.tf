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

/*
variable "les" {
  description = "The Logical Environment Specifier (LES). Can be either \"dev\", \"sbx\", \"stg\" or \"prd\"."
  type        = string
  nullable    = false
}
*/

variable "zone_name" {
  description = "The hosted zone name of the desired hosted (DNS) zone in Route 53."
  type        = string
  nullable    = false
}

variable "private_zone" {
  description = "Used with the zone_name variable to get a private hosted zone in Route 53."
  type        = bool
  nullable    = false
  default     = false
}

variable "name" {
  description = "The name of the Route 53 record to be created. It will be concatenated to the hosted zone name to generate the FQDN."
  type        = string
  nullable    = false
}
/*
variable "records" {
  description = "A string list of records."
  type        = string
  nullable    = false
}
*/

variable "records" {
  description = "(Required for non-alias records) A string list of records"
  type        = list(string)
  default     = []
}

variable "replication_group_id" {
  description = "The primary Redis cluster/replication group identifier. This parameter is stored as a lowercase string."
  type        = string
  nullable    = false
}