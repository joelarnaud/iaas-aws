account_id = "048320708175"

kinesis_parameter_arn = "/production/common/log-cloudwatch-to-splunk/kinesis_arn"

name_cloudwatch_logs_to_ship = [
  "/aws/rds/cluster/trxbkg-6157-prd-aurora-postgres/postgresql"
]

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

cloudwatch_to_firehose_trust_iam_role_name = "Custom-CloudWatchToSplunkFirehoseTrust"
cloudwatch_to_fh_access_policy_name        = "KinesisCloudWatchToFirehosePolicy"
cloudwatch_log_filter_name                 = "KinesisSubscriptionFilter"

kms_key_arn    = "arn:aws:kms:ca-central-1:526062930638:alias/6157-prd-com_cloudwatch_ca-central-1"
kms_key_arn_dr = "arn:aws:kms:eu-west-1:526062930638:alias/6157-prd-com_cloudwatch_eu-west-1"