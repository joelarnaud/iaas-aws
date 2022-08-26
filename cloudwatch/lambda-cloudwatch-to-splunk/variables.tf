variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
}

variable "s3_existing_package" {
  description = "The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use"
  type        = map(string)
}

variable "s3_existing_package_dr" {
  description = "The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use"
  type        = map(string)
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
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
  default     = ""
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

variable "policy_lambda" {
  description = "The path of the policy in IAM (json file) for Lambda"
  type        = string
}

variable "name_ssm_parameter_lambda_arn" {
  description = "Name of the ssm parameter"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified a new KMS key will be created in your account"
  type        = string
  default     = null
}

variable "kms_key_arn_dr" {
  description = "The ARN for the KMS encryption key in the secondary region. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified a new KMS key will be created in your account"
  type        = string
  default     = null
}

variable "les" {
  type        = string
  description = "The Logical Environment Specifier (LES). Can be either \"sbx\", \"dev\", \"stg\" or \"prd\"."
}