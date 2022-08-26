output "record_fqdn" {
  description = "The FQDN (fully qualified domaine name) built using the hosted zone domain and the record name."
  value       = module.redis_cluster_record.record_fqdn
}

output "hosted_zone_id" {
  description = "The ID of the hosted zone in which the record is created."
  value       = data.aws_route53_zone.hosted_zone.zone_id
}

output "primary_region" {
  description = "The AWS primary region hosting the ElastiCache cluster (Redis primary replication group)."
  value       = var.region
}