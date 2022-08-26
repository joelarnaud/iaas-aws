output "aws_region" {
  description = "The AWS primary region."
  value       = local.region
}

output "source_code_move_file_id" {
  description = "The ID of the move file object"
  value       = aws_s3_bucket_object.source_code_move_file.id
}

output "source_code_bucket" {
  description = "The name of the source code bucket"
  value       = var.bucket
}