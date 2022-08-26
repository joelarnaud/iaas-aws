output "replication_group_nodes_id" {
  description = "Contains the identifiers of all the nodes that are part of the ElastiCache Redis primary replication group."
  value       = module.redis_cluster.id
}

output "replication_group_id" {
  description = "The ID of the primary ElastiCache replication group."
  value       = var.replication_group_id
}

output "nodes_number" {
  description = "The total number of nodes in the ElastiCache Redis primary replication group."
  value       = (var.replicas_per_node_group + 1) * var.num_node_groups
}

output "primary_region" {
  description = "The AWS primary region hosting the ElastiCache cluster (Redis primary replication group)."
  value       = var.region
}