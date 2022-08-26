output "aws_region" {
  description = "The AWS primary region."
  value       = local.region
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda_function.lambda_function_name
}

output "lambda_function_handler" {
  description = "Lambda Function entrypoint in your code"
  value       = module.lambda_function.lambda_function_handler
}

output "lambda_function_runtime" {
  description = "Lambda Function runtime"
  value       = module.lambda_function.lambda_function_runtime
}