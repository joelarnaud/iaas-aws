resource "aws_cloudwatch_log_group" "sandbox" {
  count             = var.isSandbox ? 1 : 0
  name              = var.log_group_name
  retention_in_days = 1
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "to_kinesis" {
  for_each        = toset(var.name_cloudwatch_logs_to_ship)
  name            = var.cloudwatch_log_filter_name
  role_arn        = var.iam_role
  destination_arn = var.kinesis_parameter_value
  log_group_name  = each.key
  filter_pattern  = ""

  depends_on = [
    aws_cloudwatch_log_group.sandbox
  ]
}