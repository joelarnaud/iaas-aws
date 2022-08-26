account_id = "048320708175"

vault_splunk_hec_path = "secret/applications/6157/production/production/splunk"
hec_url               = "https://http-inputs-firehose-nbc.splunkcloud.com:443/services/collector"

tags = {
  copyright        = "National Bank of Canada"
  project_name     = "6157-prd-com"
  tag_domain       = "TRXBKG"
  email_support    = "SI-Bancaire-Monitoring@bnc.ca"
  support_group    = "BNC-APPL-DOM-BANCAIRE"
  asset_owner      = "soufiane.khouya@bnc.ca"
  jira_project_key = "DTB"
  account          = "RUN"
  environment      = "production"
  application_id   = "6157"
}

name_ssm_parameter_kinesis_arn = "/production/common/log-cloudwatch-to-splunk/kinesis_arn"
name_ssm_parameter_s3_arn      = "/production/common/log-cloudwatch-to-splunk/s3_kinesis_arn"
name_ssm_parameter_lambda_arn  = "/production/common/log-cloudwatch-to-splunk/lambda_arn"

kinesis_firehose_role_name       = "Custom-KinesisFirehoseRole"
kinesis_firehose_iam_policy_name = "KinesisFirehose-Policy"
firehose_name                    = "kinesis-firehose-to-splunk"

aws_cloudwatch_log_group_name  = "/aws/kinesisfirehose/kinesis-firehose-to-splunk"
aws_cloudwatch_log_stream_name = "SplunkDelivery"

kms_key_id    = "arn:aws:kms:ca-central-1:526062930638:alias/6157-prd-com_s3_ca-central-1"
kms_key_id_dr = "arn:aws:kms:eu-west-1:526062930638:alias/6157-prd-com_s3_eu-west-1"

kms_key_cloudwatch_arn    = "arn:aws:kms:ca-central-1:526062930638:alias/6157-prd-com_cloudwatch_ca-central-1"
kms_key_cloudwatch_arn_dr = "arn:aws:kms:eu-west-1:526062930638:alias/6157-prd-com_cloudwatch_eu-west-1"