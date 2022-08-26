variable "name_ssm_parameter_input" {
  description = "S3 bucket arn to store into SSM "
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tag_environment" {
  description = "Inform the environment in which you deploy your resource"
  type        = string
}

variable "tag_applicationid" {
  description = "Fill in the application ID number"
  type        = string
}

variable "tag_support_group" {
  description = "Fill in the name of the resource's support group"
  type        = string
}

variable "tag_email_support" {
  description = "Fill the email address of the resource's support team."
  type        = string
}

variable "tag_account" {
  description = "Fill in the name of the account"
  type        = string
}

variable "tag_asset_owner" {
  description = "Fill in the name of the asset owner"
  type        = string
}

variable "tag_jira_project_key" {
  description = "Fill in the name of the jira project key"
  type        = string
}

variable "enable_s3_notification" {
  description = "enable or disable allow notification S3"
  type        = bool
  default     = false
}

variable "enable_s3_replication" {
  description = "enable or disable allow replication S3"
  type        = bool
  default     = false
}

variable "bucket" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = null
}