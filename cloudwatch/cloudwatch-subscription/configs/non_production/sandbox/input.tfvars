account_id = "536342756088"

kinesis_parameter_arn = "/nonprod/sandbox/log-cloudwatch-to-splunk/kinesis_arn"

sandbox_cloudwatch_log_group_name = "/aws/cloudwatch-log-group/cloudwatch-log-group-sbx"

name_cloudwatch_logs_to_ship = [
  "/aws/rds/cluster/trxbkg-6157-sbx-aurora-postgres/postgresql"
]

isSandbox = true

tags = {
  copyright        = "National Bank of Canada"
  project_name     = "6157-npr-com"
  tag_domain       = "TRXBKG"
  email_support    = "SI-Bancaire-Monitoring@bnc.ca"
  support_group    = "BNC-APPL-DOM-BANCAIRE"
  asset_owner      = "soufiane.khouya@bnc.ca"
  jira_project_key = "DTB"
  account          = "RUN"
  environment      = "non-production"
  application_id   = "6157"
}

cloudwatch_to_firehose_trust_iam_role_name = "Custom-CloudWatchToSplunkFirehoseTrust-sbx"
cloudwatch_to_fh_access_policy_name        = "KinesisCloudWatchToFirehosePolicy-sbx"
cloudwatch_log_filter_name                 = "KinesisSubscriptionFilter-sbx"

kms_key_arn    = "arn:aws:kms:ca-central-1:428043142470:alias/6157-npr-com_cloudwatch_ca-central-1"
kms_key_arn_dr = "arn:aws:kms:eu-west-1:428043142470:alias/6157-npr-com_cloudwatch_eu-west-1"