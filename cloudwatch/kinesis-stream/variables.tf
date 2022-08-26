variable "name_ssm_parameter_s3_arn" {
  type        = string
  description = "Arn of s3 bucket used by kinesis from SSM"
}

variable "name_ssm_parameter_lambda_arn" {
  type        = string
  description = "Arn of lambda function processed by kinesis"
}

variable "aws_cloudwatch_log_group_name" {
  type        = string
  description = "Kinesis cloudwatch log group name"
}

variable "name_ssm_parameter_kinesis_arn" {
  type        = string
  description = "Kinesis arn from SSM"
}

variable "hec_url" {
  type        = string
  description = "Splunk Kinesis URL for submitting CloudWatch logs to splunk"
}

variable "vault_splunk_hec_path" {
  type        = string
  description = "Vault path to get splunk security token"
}

variable "firehose_name" {
  type        = string
  description = "Name of the Kinesis Firehose"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to put on the resource"
}

variable "kinesis_firehose_role_name" {
  type        = string
  description = "Name of IAM Role for the Kinesis Firehose"
}

variable "kinesis_firehose_iam_policy_name" {
  type        = string
  description = "Name of the IAM Policy attached to IAM Role for the Kinesis Firehose"
}

variable "aws_cloudwatch_log_stream_name" {
  type        = string
  description = "Name of the CloudWatch log stream for Kinesis Firehose CloudWatch log group"
}

variable "account_id" {
  type        = string
  description = "Account ID of the owner"
}

variable "kms_key_id" {
  type        = string
  description = "The ARN of the KMS key used by the S3 bucket in the primary region."
}

variable "kms_key_id_dr" {
  type        = string
  description = "The ARN of the KMS key used by the S3 bucket in the secondary region."
}

variable "kms_key_cloudwatch_arn" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "kms_key_cloudwatch_arn_dr" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}