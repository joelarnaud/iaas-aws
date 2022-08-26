variable "isSandbox" {
  type        = bool
  description = "A flag for sandbox"
}

variable "log_group_name" {
  type        = string
  description = "The name of the log group. If omitted, Terraform will assign a random, unique name."
}

variable "name_cloudwatch_logs_to_ship" {
  type        = list(string)
  description = "List of group names that you want to ship to Splunk."
}

variable "cloudwatch_log_filter_name" {
  type        = string
  description = "Name of Log Filter for CloudWatch Log subscription to Kinesis Firehose"
}

variable "iam_role" {
  type        = string
  description = "The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination."
}

variable "kinesis_parameter_value" {
  type        = string
  description = "The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN."
}

variable "kms_key_id" {
  type        = string
  description = "The ARN of the KMS Key to use when encrypting log data."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}