output "log_group_arn" {
  description = "The ARN of log group."
  value       = aws_cloudwatch_log_group.this.arn
}

output "log_stream_arn" {
  description = "The ARN of log stream."
  value       = aws_cloudwatch_log_stream.this.arn
}