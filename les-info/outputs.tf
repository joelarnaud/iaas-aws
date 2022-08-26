output "database_name" {
  value       = local.database_name
  description = "The name of the database according to the provided LES (\"sbx\", \"dev\", \"stg\" or \"prd\") value."
}

output "master_username" {
  value       = local.master_username
  description = "The master username for the database."
}

output "cluster_identifier" {
  value       = local.cluster_identifier
  description = "The identifier (name) of the cluster containing the database based on the provided LES (\"sbx\", \"dev\", \"stg\" or \"prd\") value."
}

output "kms_administrators_arn" {
  value       = local.kms_administrators_arn
  description = "The ARN of the IAM identity (role) in the AWS account having the administrator permissions for the KMS."
}

output "base_vault_path" {
  value       = local.base_vault_path
  description = "The base path for storing secrets in the vault."
}

output "vault_path_sep" {
  value       = "/"
  description = " The vault path separator symbol if one wants to dynamically separate path elements outside of this module."
}

output "is_production" {
  value       = local.is_production
  description = "A flag indicating whether the provided LES value corresponds to a production environment."
}

output "is_staging" {
  value       = local.is_staging
  description = "A flag indicating whether the provided LES value corresponds to a staging environment."
}

output "is_development" {
  value       = local.is_development
  description = "A flag indicating whether the provided LES value corresponds to a development environment."
}

output "paap_style_env" {
  value       = local.paap_style_env
  description = "The selected environment based on the provided LES value. Can be either \"development\", \"staging\" or \"production\"."
}

output "vpc_id" {
  value       = local.vpc_id
  description = "The VPC ID based on the selected environment (production or non-production) for the primary region."
}

output "dr_vpc_id" {
  value       = local.dr_vpc_id
  description = "The VPC ID based on the selected environment (production or non-production) for the secondary (disaster recovery) region."
}

output "vpc_subnet_ids_sorted" {
  value       = local.vpc_subnet_ids_sorted
  description = "The sorted VPC subnets for the zones in the primary region based on the selected environment (production or non-production)."
}

output "dr_vpc_subnet_ids_sorted" {
  value       = local.dr_vpc_subnet_ids_sorted
  description = "The sorted VPC subnets for the zones in the secondary (disaster recovery) region based on the selected environment (production or non-production)."
}

output "db_security_group_name" {
  value       = local.db_security_group_name
  description = "The name of the security group for the database depending on the provided LES value."
}

output "all_users" {
  value       = local.all_users
  description = <<-EOT
A map of all the users (for the provided LES value) containing the database schema name for the microservice, the according environment ("sbx", "dev", "stg" or "prd"), the microservice name in the vault and the associated type ("fw", "rw" or "ro").
The result will look as follow:
all_users = {
  microserviceNameA_environmentNameA_fw = {
    environment = "environmentNameA"
    schema = "microserviceNameA_environmentNameA"
    type = "fw"
    vault_microservice = "microserviceNameA"
  }
  microserviceNameA_environmentNameA_ro = {
    environment = "environmentNameA"
    schema = "microserviceNameA_environmentNameA"
    type = "ro"
    vault_microservice = "microserviceNameA"
  }
  microserviceNameA_environmentNameA_rw = {
    environment = "environmentNameA"
    schema = "microserviceNameA_environmentNameA"
    type = "rw"
    vault_microservice = "microserviceNameA"
  }
...
}
EOT
}

output "all_schemas" {
  value       = local.all_schemas
  description = <<-EOT
A map of all the schemas (for the provided LES value) containing the database schema name for the microservice, the according environment ("sbx", "dev", "stg" or "prd") and the microservice name in the vault.
The result will look as follow:
all_schemas = {
  microserviceNameA_environmentNameA = {
    environment = "environmentNameA"
    schema = "microserviceNameA_environmentNameA"
    vault_microservice = "microserviceNameA"
  }
  microserviceNameA_environmentNameB = {
    environment = "environmentNameB"
    schema = "microserviceNameA_environmentNameB"
    vault_microservice = "microserviceNameA"
  }
...
}
EOT
}

output "istio_aurora_db_client_port" {
  value       = local.istio_aurora_db_client_port
  description = <<-EOT
The Istio client port for the main writer.
Note that a few related client port values will be derived from it too (main reader, secondary writer and secondary reader).
EOT
}

output "istio_aurora_db_reader_client_port" {
  value       = local.istio_aurora_db_reader_client_port
  description = "The Istio client port for the main reader."
}

output "istio_aurora_db_dr_client_port" {
  value       = local.istio_aurora_db_dr_client_port
  description = "The Istio client port for the secondary (disaster recovery) writer."
}

output "istio_aurora_db_dr_reader_client_port" {
  value       = local.istio_aurora_db_dr_reader_client_port
  description = "The Istio client port for the secondary (disaster recovery) reader."
}

output "operational_lambda_security_group_name" {
  value       = local.operational_lambda_security_group_name
  description = "The name of the security group for lambda function, used to interact with some aws API."
}

output "direct_to_internet_security_group_name" {
  value       = local.direct_to_internet_security_group_name
  description = "The name of the security group for direct to internet."
}