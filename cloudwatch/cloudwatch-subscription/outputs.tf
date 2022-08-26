output "aws_region" {
  description = "The AWS primary region."
  value       = local.region
}

output "log_group_name" {
  description = "Kinesis cloudwatch log group name in use"
  value       = var.name_cloudwatch_logs_to_ship[0]
}