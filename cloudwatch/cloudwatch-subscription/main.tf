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

data "aws_ssm_parameter" "ssm_kms_kinesis_parameter" {
  name = var.kinesis_parameter_arn
}

data "aws_ssm_parameter" "ssm_kms_kinesis_parameter_dr" {
  name     = "${var.kinesis_parameter_arn}-dr"
  provider = aws.dr
}

data "aws_kms_key" "log_group" {
  key_id = var.kms_key_arn
}

data "aws_kms_key" "log_group_dr" {
  provider = aws.dr
  key_id   = var.kms_key_arn_dr
}

resource "aws_iam_role" "cloudwatch_to_firehose_trust" {
  name                 = var.cloudwatch_to_firehose_trust_iam_role_name
  description          = "Role for CloudWatch Log Group subscription"
  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/DatadogBoundary"
  assume_role_policy   = <<ROLE
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.${local.region}.amazonaws.com"
      }
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.${local.region_dr}.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
ROLE
}

data "aws_iam_policy_document" "cloudwatch_to_fh_access_policy" {
  statement {
    actions = [
      "firehose:*",
    ]

    effect = "Allow"

    resources = [
      data.aws_ssm_parameter.ssm_kms_kinesis_parameter.value,
      data.aws_ssm_parameter.ssm_kms_kinesis_parameter_dr.value,
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    effect = "Allow"

    resources = [
      aws_iam_role.cloudwatch_to_firehose_trust.arn,
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_to_fh_access_policy" {
  name        = var.cloudwatch_to_fh_access_policy_name
  description = "Cloudwatch to Firehose Subscription Policy"
  policy      = data.aws_iam_policy_document.cloudwatch_to_fh_access_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_to_fh" {
  role       = aws_iam_role.cloudwatch_to_firehose_trust.name
  policy_arn = aws_iam_policy.cloudwatch_to_fh_access_policy.arn
}

module "logs_group_and_subscription_filter" {
  source                       = "./modules/logs-group-and-subscription-filter"
  isSandbox                    = var.isSandbox
  log_group_name               = var.sandbox_cloudwatch_log_group_name
  name_cloudwatch_logs_to_ship = var.name_cloudwatch_logs_to_ship
  cloudwatch_log_filter_name   = var.cloudwatch_log_filter_name
  iam_role                     = aws_iam_role.cloudwatch_to_firehose_trust.arn
  kinesis_parameter_value      = data.aws_ssm_parameter.ssm_kms_kinesis_parameter.value
  kms_key_id                   = data.aws_kms_key.log_group.arn
  tags                         = var.tags
}

module "logs_group_and_subscription_filter_dr" {
  source = "./modules/logs-group-and-subscription-filter"
  providers = {
    aws = aws.dr
  }
  isSandbox                    = var.isSandbox
  log_group_name               = "${var.sandbox_cloudwatch_log_group_name}-dr"
  name_cloudwatch_logs_to_ship = var.name_cloudwatch_logs_to_ship
  cloudwatch_log_filter_name   = "${var.cloudwatch_log_filter_name}-dr"
  iam_role                     = aws_iam_role.cloudwatch_to_firehose_trust.arn
  kinesis_parameter_value      = data.aws_ssm_parameter.ssm_kms_kinesis_parameter_dr.value
  kms_key_id                   = data.aws_kms_key.log_group_dr.arn
  tags                         = var.tags
}