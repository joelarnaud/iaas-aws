resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = 30
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_kinesis_firehose_delivery_stream" "to_splunk" {
  depends_on = [
    aws_cloudwatch_log_stream.this
  ]
  name        = var.firehose_name
  destination = "splunk"

  s3_configuration {
    role_arn           = var.role_arn
    prefix             = "kinesis-firehose/"
    bucket_arn         = var.bucket_arn
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }

  splunk_configuration {
    hec_endpoint               = var.hec_url
    hec_token                  = var.hec_token
    hec_acknowledgment_timeout = 300
    hec_endpoint_type          = "Raw"
    s3_backup_mode             = "FailedEventsOnly"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = var.parameter_value_lambda
        }
        parameters {
          parameter_name  = "RoleArn"
          parameter_value = var.parameter_value_role
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = var.log_group_name
      log_stream_name = var.log_stream_name
    }
  }
  tags = var.tags
}

resource "aws_ssm_parameter" "this" {
  name        = var.parameter_store_name
  description = "lambda move error file ARN"
  type        = "String"
  value       = aws_kinesis_firehose_delivery_stream.to_splunk.arn

  tags = var.tags
}