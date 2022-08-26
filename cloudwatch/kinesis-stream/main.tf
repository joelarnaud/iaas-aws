provider "aws" {
  region = local.region
}

provider "aws" {
  region = local.region_dr
  alias  = "dr"
}

locals {
  region    = "ca-central-1"
  region_dr = "eu-west-1"
}

provider "vault" {
  add_address_to_env    = false
  token_name            = "terraform-log-cloudwatch-to-splunk-${formatdate("YYYYMMDDhhmmssZZZ", timestamp())}"
  skip_tls_verify       = true # Used to run tf script in local
  max_lease_ttl_seconds = 3600 # Will be limited by parent token TTL
  max_retries           = 2
}

data "aws_ssm_parameter" "kinesis_firehose_s3_bucket_arn" {
  name = var.name_ssm_parameter_s3_arn
}

data "aws_ssm_parameter" "kinesis_firehose_s3_bucket_arn_dr" {
  name     = "${var.name_ssm_parameter_s3_arn}-dr"
  provider = aws.dr
}

data "aws_ssm_parameter" "lambda_arn" {
  name = var.name_ssm_parameter_lambda_arn
}

data "aws_ssm_parameter" "lambda_arn_dr" {
  name     = "${var.name_ssm_parameter_lambda_arn}-dr"
  provider = aws.dr
}

data "vault_generic_secret" "vault_hec_token_secret" {
  path = var.vault_splunk_hec_path
}

data "aws_kms_key" "log_group" {
  key_id = var.kms_key_cloudwatch_arn
}

data "aws_kms_key" "log_group_dr" {
  provider = aws.dr
  key_id   = var.kms_key_cloudwatch_arn_dr
}

module "kinesis_delivery_stream" {
  source                 = "./modules/logs-delivery-stream"
  log_group_name         = var.aws_cloudwatch_log_group_name
  log_stream_name        = var.aws_cloudwatch_log_stream_name
  tags                   = var.tags
  firehose_name          = var.firehose_name
  role_arn               = aws_iam_role.kinesis_firehose.arn
  bucket_arn             = data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn.value
  hec_token              = data.vault_generic_secret.vault_hec_token_secret.data.hec_token
  hec_url                = var.hec_url
  parameter_value_lambda = "${data.aws_ssm_parameter.lambda_arn.value}:$LATEST"
  parameter_value_role   = aws_iam_role.kinesis_firehose.arn
  parameter_store_name   = var.name_ssm_parameter_kinesis_arn
  kms_key_id             = data.aws_kms_key.log_group.arn
}

module "kinesis_delivery_stream_dr" {
  source = "./modules/logs-delivery-stream"
  providers = {
    aws = aws.dr
  }
  log_group_name         = "${var.aws_cloudwatch_log_group_name}-dr"
  log_stream_name        = "${var.aws_cloudwatch_log_stream_name}-dr"
  tags                   = var.tags
  firehose_name          = "${var.firehose_name}-dr"
  role_arn               = aws_iam_role.kinesis_firehose.arn
  bucket_arn             = data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn_dr.value
  hec_token              = data.vault_generic_secret.vault_hec_token_secret.data.hec_token
  hec_url                = var.hec_url
  parameter_value_lambda = "${data.aws_ssm_parameter.lambda_arn_dr.value}:$LATEST"
  parameter_value_role   = aws_iam_role.kinesis_firehose.arn
  parameter_store_name   = "${var.name_ssm_parameter_kinesis_arn}-dr"
  kms_key_id             = data.aws_kms_key.log_group_dr.arn
}

data "aws_kms_key" "s3_kms_key" {
  key_id = var.kms_key_id
}

data "aws_kms_key" "s3_kms_key_dr" {
  provider = aws.dr
  key_id   = var.kms_key_id_dr
}

# Role for Kenisis Firehose
resource "aws_iam_role" "kinesis_firehose" {
  name                 = var.kinesis_firehose_role_name
  description          = "IAM Role for Kenisis Firehose"
  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/DatadogBoundary"
  assume_role_policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Effect": "Allow"
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "kinesis_firehose_policy_document" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn.value,
      "${data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn.value}/*",
      data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn_dr.value,
      "${data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn_dr.value}/*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "${data.aws_ssm_parameter.lambda_arn.value}:$LATEST",
      "${data.aws_ssm_parameter.lambda_arn_dr.value}:$LATEST",
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      module.kinesis_delivery_stream.log_group_arn,
      module.kinesis_delivery_stream.log_stream_arn,
      module.kinesis_delivery_stream_dr.log_group_arn,
      module.kinesis_delivery_stream_dr.log_stream_arn
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      data.aws_kms_key.s3_kms_key.arn,
      data.aws_kms_key.s3_kms_key_dr.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "s3.${local.region}.amazonaws.com",
        "s3.${local.region_dr}.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        "${data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn.value}/*",
        "${data.aws_ssm_parameter.kinesis_firehose_s3_bucket_arn_dr.value}/*"
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_policy" "kinesis_firehose_iam_policy" {
  name   = var.kinesis_firehose_iam_policy_name
  policy = data.aws_iam_policy_document.kinesis_firehose_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kinesis_fh_role_attachment" {
  role       = aws_iam_role.kinesis_firehose.name
  policy_arn = aws_iam_policy.kinesis_firehose_iam_policy.arn
}