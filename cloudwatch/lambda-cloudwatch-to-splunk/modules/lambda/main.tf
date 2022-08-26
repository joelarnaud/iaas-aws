module "lambda" {
  source                 = "git::https://git.bnc.ca/scm/APP15201/terraform-aws-lambda.git?ref=v5.0.0"
  region                 = var.region
  function_name          = var.function_name
  description            = var.description
  handler                = var.handler
  runtime                = var.runtime
  lambda_role            = var.lambda_role
  vpc_security_group_ids = var.vpc_security_group_ids
  kms_key_arn            = var.kms_key_arn
  s3_existing_package    = var.s3_existing_package

  tags              = var.tags
  tag_environment   = var.tag_environment
  tag_applicationid = var.tag_applicationid
  tag_support       = var.tag_support_group
  tag_email_support = var.tag_email_support
  tag_account       = var.tag_account
  tag_owner         = var.tag_asset_owner
  tag_projectjira   = var.tag_jira_project_key
}

resource "aws_ssm_parameter" "this" {
  name        = var.parameter_store_name
  description = "lambda move error file ARN"
  type        = "String"
  value       = module.lambda.lambda_function_arn

  tags = var.tags
}