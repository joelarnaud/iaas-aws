output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda.lambda_function_name
}

output "lambda_function_handler" {
  description = "Lambda Function entrypoint in your code"
  value       = module.lambda.lambda_function_handler
}

output "lambda_function_runtime" {
  description = "Lambda Function runtime"
  value       = module.lambda.lambda_function_runtime
}