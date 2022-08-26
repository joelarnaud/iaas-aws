variable "log_group_name" {
  type        = string
  description = "Cloudwatch log group name"
}

variable "log_stream_name" {
  type        = string
  description = "Name of the CloudWatch log stream for Kinesis Firehose CloudWatch log group"
}

variable "firehose_name" {
  type        = string
  description = "Name of the Kinesis Firehose"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the role"
}

variable "bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
}

variable "hec_token" {
  type        = string
  description = "Vault path to get splunk security token"
}

variable "hec_url" {
  type        = string
  description = "Splunk Kinesis URL for submitting CloudWatch logs to splunk"
}

variable "parameter_value_lambda" {
  type        = string
  description = "The ARN of the lambda"
}

variable "parameter_value_role" {
  type        = string
  description = "The ARN value of the role"
}

variable "parameter_store_name" {
  description = "The Name in Parameter Store."
  type        = string
}

variable "kms_key_id" {
  type        = string
  description = "The ARN of the KMS Key to use when encrypting log data."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}