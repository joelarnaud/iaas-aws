variable "region" {
  type        = string
  description = "The AWS primary region."
}

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

variable "parameter_store_name" {
  description = "Name of the ssm parameter"
  type        = string
}

variable "lambda_role" {
  description = "The IAM Role used for Lambda"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security groups of the shared vpc "
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The kms key for a specified region"
  type        = string
}