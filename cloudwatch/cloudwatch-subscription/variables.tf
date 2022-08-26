variable "kinesis_parameter_arn" {
  type        = string
  description = "Kinesis arn from SSM"
}

variable "cloudwatch_to_firehose_trust_iam_role_name" {
  type        = string
  description = "IAM Role name for CloudWatch to Kinesis Firehose subscription"
}

variable "cloudwatch_to_fh_access_policy_name" {
  type        = string
  description = "Name of IAM policy attached to the IAM role for CloudWatch to Kinesis Firehose subscription"
}

variable "cloudwatch_log_filter_name" {
  type        = string
  description = "Name of Log Filter for CloudWatch Log subscription to Kinesis Firehose"
}

variable "name_cloudwatch_logs_to_ship" {
  type        = list(string)
  description = "List of group names that you want to ship to Splunk."
}

variable "account_id" {
  type        = string
  description = "Account ID of the owner"
}

variable "sandbox_cloudwatch_log_group_name" {
  type        = string
  description = "Cloudwatch log group name used in sandbox environment"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "kms_key_arn_dr" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to put on the resource"
}

variable "isSandbox" {
  type        = bool
  default     = false
  description = "A flag for sandbox"
}