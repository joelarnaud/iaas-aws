provider "aws" {
  region = local.region
}

provider "aws" {
  alias  = "dr"
  region = local.region_dr
}

locals {
  region    = "ca-central-1"
  region_dr = "eu-west-1"
}

data "aws_kms_key" "kms_key_arn" {
  key_id = var.kms_key_arn
}

data "aws_kms_key" "kms_key_arn_dr" {
  key_id   = var.kms_key_arn_dr
  provider = aws.dr
}

data "aws_s3_object" "info_version_id" {
  bucket = lookup(var.s3_existing_package, "bucket", null)
  key    = lookup(var.s3_existing_package, "key", null)
}

data "aws_s3_object" "info_version_id_dr" {
  bucket   = lookup(var.s3_existing_package_dr, "bucket", null)
  key      = lookup(var.s3_existing_package_dr, "key", null)
  provider = aws.dr
}

module "les_info" {
  source = "git::https://git.bnc.ca/scm/app6157/terraform-module-les-info.git?ref=v1.4.8"
  les    = var.les
  app_id = "6157"
}

data "aws_security_groups" "internet" {
  filter {
    name   = "group-name"
    values = [module.les_info.direct_to_internet_security_group_name]
  }
  filter {
    name   = "vpc-id"
    values = [module.les_info.vpc_id]
  }
}

data "aws_security_groups" "internet_dr" {
  filter {
    name   = "group-name"
    values = [module.les_info.direct_to_internet_security_group_name]
  }
  filter {
    name   = "vpc-id"
    values = [module.les_info.dr_vpc_id]
  }
  provider = aws.dr
}

module "lambda_function" {
  source                 = "./modules/lambda"
  region                 = local.region
  function_name          = var.function_name
  description            = var.description
  handler                = var.handler
  runtime                = var.runtime
  lambda_role            = aws_iam_role.lambda.arn
  vpc_security_group_ids = data.aws_security_groups.internet.ids
  kms_key_arn            = data.aws_kms_key.kms_key_arn.arn

  s3_existing_package = {
    bucket     = data.aws_s3_object.info_version_id.bucket
    key        = data.aws_s3_object.info_version_id.key
    version_id = data.aws_s3_object.info_version_id.version_id
  }

  tags                 = var.tags
  tag_environment      = var.tag_environment
  tag_applicationid    = var.tag_applicationid
  tag_support_group    = var.tag_support_group
  tag_email_support    = var.tag_email_support
  tag_account          = var.tag_account
  tag_asset_owner      = var.tag_asset_owner
  tag_jira_project_key = var.tag_jira_project_key
  parameter_store_name = var.name_ssm_parameter_lambda_arn
}

module "lambda_function_dr" {
  source = "./modules/lambda"
  providers = {
    aws = aws.dr
  }
  region                 = local.region_dr
  function_name          = "${var.function_name}-dr"
  description            = var.description
  handler                = var.handler
  runtime                = var.runtime
  lambda_role            = aws_iam_role.lambda.arn
  vpc_security_group_ids = data.aws_security_groups.internet_dr.ids
  kms_key_arn            = data.aws_kms_key.kms_key_arn_dr.arn

  s3_existing_package = {
    bucket     = data.aws_s3_object.info_version_id_dr.bucket
    key        = data.aws_s3_object.info_version_id_dr.key
    version_id = data.aws_s3_object.info_version_id_dr.version_id
  }

  tags                 = var.tags
  tag_environment      = var.tag_environment
  tag_applicationid    = var.tag_applicationid
  tag_support_group    = var.tag_support_group
  tag_email_support    = var.tag_email_support
  tag_account          = var.tag_account
  tag_asset_owner      = var.tag_asset_owner
  tag_jira_project_key = var.tag_jira_project_key
  parameter_store_name = "${var.name_ssm_parameter_lambda_arn}-dr"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda" {
  name                 = "Custom-role-${var.function_name}"
  permissions_boundary = format("arn:aws:iam::%s:policy/LambdaExecutionBoundary", data.aws_caller_identity.current.account_id)
  assume_role_policy   = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
       "Effect": "Allow",
        "Sid": ""
     }
    ]
  }
  POLICY
}

resource "aws_iam_policy" "lambda" {
  name   = "iam-policy-lambda-${var.function_name}"
  policy = file(var.policy_lambda)
}

resource "aws_iam_policy_attachment" "lambda" {
  name       = "policy-attach-${var.function_name}"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.lambda.arn
}