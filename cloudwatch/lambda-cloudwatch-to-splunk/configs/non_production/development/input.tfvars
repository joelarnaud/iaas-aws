les = "dev"

function_name = "lambda-cloudwatch-to-splunk-dev"

description = "lambda function send cloudwatch logs to splunk"
handler     = "splunk.handler"
runtime     = "nodejs12.x"

s3_existing_package = {
  bucket = "6157-source-code-lambda-cloudwatch-to-splunk-dev"
  key    = "src/splunk/splunk.zip"
}

tags = {
  copyright    = "National Bank of Canada"
  project_name = "6157-npr-com"
  tag_domain   = "TRXBKG"
}

tag_environment      = "non-production"
tag_applicationid    = "6157"
tag_email_support    = "SI-Bancaire-Monitoring@bnc.ca"
tag_support_group    = "BNC-APPL-DOM-BANCAIRE"
tag_asset_owner      = "soufiane.khouya@bnc.ca"
tag_jira_project_key = "DTB"
tag_account          = "RUN"

policy_lambda = "./policy/policy.json"

name_ssm_parameter_lambda_arn = "/nonprod/development/log-cloudwatch-to-splunk/lambda_arn"

kms_key_arn    = "arn:aws:kms:ca-central-1:428043142470:alias/6157-npr-com_lambda_ca-central-1"
kms_key_arn_dr = "arn:aws:kms:eu-west-1:428043142470:alias/6157-npr-com_lambda_eu-west-1"