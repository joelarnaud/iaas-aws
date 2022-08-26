enable_s3_replication = true

bucket = "6157-source-code-lambda-cloudwatch-to-splunk-dev"

enable_s3_notification = false

tags = {
  copyright    = "National Bank of Canada"
  project_name = "6157-npr-com"
  tag_domain   = "TRXBKG"
}

tag_email_support    = "SI-Bancaire-Monitoring@bnc.ca"
tag_support_group    = "BNC-APPL-DOM-BANCAIRE"
tag_asset_owner      = "soufiane.khouya@bnc.ca"
tag_jira_project_key = "DTB"
tag_account          = "RUN"
tag_environment      = "non-production"
tag_applicationid    = "6157"

name_ssm_parameter_input = "/nonprod/development/log-cloudwatch-to-splunk/s3-source-code-lambda"