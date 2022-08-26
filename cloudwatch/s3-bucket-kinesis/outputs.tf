output "aws_region" {
  description = "The AWS primary region."
  value       = local.region
}

output "aws_region_dr" {
  description = "The AWS region for Disaster Recovery."
  value       = local.region_dr
}

output "bucket_id_replica" {
  description = "The name of the bucket replication."
  value       = module.s3_kinesis_replication.*.bucket_id_replica
}

output "bucket_region_replica" {
  description = "The AWS region of the bucket replication resides in."
  value       = module.s3_kinesis_replication.*.bucket_region_replica
}

output "bucket_id_origin" {
  description = "The name of the bucket origin."
  value       = module.s3_kinesis_replication.*.bucket_id_origine
}

output "bucket_region_origin" {
  description = "The AWS region of the bucket origin resides in."
  value       = module.s3_kinesis_replication.*.bucket_region_origine
}