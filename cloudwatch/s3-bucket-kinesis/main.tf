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

module "s3_kinesis_replication" {
  source                 = "git::https://git.bnc.ca/scm/APP15201/terraform-aws-s3-bucket.git?ref=v5.0.0"
  enable_s3_replication  = var.enable_s3_replication
  bucket_origine         = var.bucket
  bucket_replica         = "${var.bucket}-dr"
  rule_status            = "Disabled"
  enable_s3_notification = var.enable_s3_notification
  tags                   = var.tags
  tag_environment        = var.tag_environment
  tag_applicationid      = var.tag_applicationid
  tag_support            = var.tag_support_group
  tag_email_support      = var.tag_email_support
  tag_account            = var.tag_account
  tag_owner              = var.tag_asset_owner
  tag_projectjira        = var.tag_jira_project_key
}

resource "aws_ssm_parameter" "s3_source_code_lambda" {
  name        = var.name_ssm_parameter_input
  description = "s3 input file ARN"
  type        = "String"
  value       = module.s3_kinesis_replication.bucket_arn_origine[0][0]
  tags        = var.tags
}

resource "aws_ssm_parameter" "s3_source_code_lambda_dr" {
  provider    = aws.dr
  name        = "${var.name_ssm_parameter_input}-dr"
  description = "s3 input file ARN"
  type        = "String"
  value       = module.s3_kinesis_replication.bucket_arn_replica[0][0]
  tags        = var.tags
}