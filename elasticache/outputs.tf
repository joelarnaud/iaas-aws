output "primary_region" {
  description = "The AWS primary region hosting the ElastiCache cluster (Redis primary replication group)."
  value       = var.region
}

#redis-cluster
output "replication_group_nodes_id" {
  description = "Contains the identifiers of all the nodes that are part of the ElastiCache Redis primary replication group."
  value       = module.elasticache_redis.replication_group_nodes_id
}

output "replication_group_id" {
  description = "The ID of the primary ElastiCache replication group."
  value       = var.cluster_id
}

output "nodes_number" {
  description = "The total number of nodes in the ElastiCache Redis primary replication group."
  value       = (var.replicas_per_node_group + 1) * var.num_node_groups
}

#route53
output "record_fqdn" {
  description = "The FQDN (fully qualified domaine name) built using the hosted zone domain and the record name."
  value       = module.route53_record.record_fqdn
}

output "hosted_zone_id" {
  description = "The ID of the hosted zone in which the record is created."
  value       = module.route53_record.hosted_zone_id
}