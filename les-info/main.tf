locals {
  # --------------------------------------------------------------------------------------------------------
  # ENVIRONMENT
  # --------------------------------------------------------------------------------------------------------
  common_microservices = []

  # --------
  # IMPORTANT
  # ---------
  # This code needs to be in line with the method getPaapStyleEnvironmentName() in the
  # src/dragonx/iac/helper/TerraformingContext.groovy in dragonx-iac-helper Groovy code!
  #
  # IF YOU CHANGE ONE CODE, CHANGE THE OTHER CODE TO MATCH THE LOGIC
  # IF YOU ADD ENVIRONMENTS, CHECK CODE ELSEWHERE TO ENSURE IT IS COVERED (ex: istio_aurora_db_client_port)
  # --------
  les_info = {
    "sbx" : {
      vaultInstance : "non_production"
      paapStyleEnvironmentName : "development",
      microservices : concat(local.common_microservices, ["micro-service-x", "account-preference-rest", "teller-transaction-rest", "teller-transaction-initiation-rest"])
      appEnvironments : ["sbx"]
    }
    "dev" : {
      vaultInstance : "non_production"
      paapStyleEnvironmentName : "development"
      microservices : concat(local.common_microservices, ["micro-service-x", "account-preference-rest", "teller-transaction-rest", "teller-transaction-initiation-rest"])
      appEnvironments : ["dev"]
    }
    "stg" : {
      vaultInstance : "non_production"
      paapStyleEnvironmentName : "staging"
      microservices : concat(local.common_microservices, ["micro-service-x", "account-preference-rest", "teller-transaction-rest", "teller-transaction-initiation-rest"])
      appEnvironments : ["stg"]
    }
    "prd" : {
      vaultInstance : "production"
      paapStyleEnvironmentName : "production"
      microservices : concat(local.common_microservices, ["account-preference-rest", "teller-transaction-rest", "teller-transaction-initiation-rest"])
      appEnvironments : ["prd"]
    }
  }

  base_vault_path = "secret/applications/${var.app_id}/${local.les_info[var.les].vaultInstance}/${local.les_info[var.les].paapStyleEnvironmentName}"

  is_production  = local.les_info[var.les].paapStyleEnvironmentName == "production" ? true : false
  is_staging     = local.les_info[var.les].paapStyleEnvironmentName == "staging" ? true : false
  is_development = local.les_info[var.les].paapStyleEnvironmentName == "development" ? true : false

  paap_style_env = local.les_info[var.les].paapStyleEnvironmentName

  # --------------------------------------------------------------------------------------------------------
  # NETWORK
  # --------------------------------------------------------------------------------------------------------
  vpc_id = local.is_production ? "vpc-06815d2baa6850994" : "vpc-06ac24b61b59e93e6"

  dr_vpc_id = local.is_production ? "vpc-0a9d72edc871d961e" : "vpc-073c8bc021af9011f"

  prd_vpc_subnet_ids_info = {
    "ca-central-1a" : "subnet-01c2d2b4aae14b15c"
    "ca-central-1b" : "subnet-00a642ebfd332158b"
    "ca-central-1d" : "subnet-084ae77f1c7604317"
  }

  npr_vpc_subnet_ids_info = {
    "ca-central-1a" : "subnet-06c832a339ca907c1"
    "ca-central-1b" : "subnet-06e87b90d76de279b"
    "ca-central-1d" : "subnet-05cd45adcd7d3906b"
  }
  vpc_subnet_ids_info = local.is_production ? local.prd_vpc_subnet_ids_info : local.npr_vpc_subnet_ids_info

  vpc_subnet_ids_sorted = sort([for k, v in local.vpc_subnet_ids_info : v])

  prd_dr_vpc_subnet_ids_info = {
    "eu-west-1a" : "subnet-0948c252954f70c52"
    "eu-west-1b" : "subnet-0b54ee1a306bc4153"
    "eu-west-1c" : "subnet-03780ba2c99badfda"
  }

  npr_dr_vpc_subnet_ids_info = {
    "eu-west-1a" : "subnet-08c5973617227bbba"
    "eu-west-1b" : "subnet-0f8fefa9af91cc9f2"
    "eu-west-1c" : "subnet-0d65966abef7f35ee"
  }

  dr_vpc_subnet_ids_info = local.is_production ? local.prd_dr_vpc_subnet_ids_info : local.npr_dr_vpc_subnet_ids_info

  dr_vpc_subnet_ids_sorted = sort([for k, v in local.dr_vpc_subnet_ids_info : v])

  db_security_group_name = "6157-aurora-postgres-${var.les}*"

  # We need to leave gaps between base client ports because of many different endpoints we may have to reach
  # - writer endpoint = base port
  # - reader endpoint = base port + 1
  # - dr writer endoint = base port + 2
  # - dr reader endpoint = base port + 3
  istio_aurora_db_npr_base_client_ports = { "sbx" : 20030
    "dev" : 20040
    "stg" : 20050
  }

  # We want to have -1 for unknown environments (ex: npr)
  istio_aurora_db_client_port           = local.is_production ? 20090 : lookup(local.istio_aurora_db_npr_base_client_ports, var.les, -1)
  istio_aurora_db_reader_client_port    = local.istio_aurora_db_client_port + 1
  istio_aurora_db_dr_client_port        = local.istio_aurora_db_client_port + 2
  istio_aurora_db_dr_reader_client_port = local.istio_aurora_db_client_port + 3

  # --------------------------------------------------------------------------------------------------------
  # CLUSTER
  # --------------------------------------------------------------------------------------------------------
  cluster_identifier = "trxbkg-6157-${var.les}-aurora-postgres"

  # --------------------------------------------------------------------------------------------------------
  # DATABASE
  # --------------------------------------------------------------------------------------------------------
  database_name = "DB6157Postgresql${title(var.les)}"

  master_username = "root"

  # Here I have cut the expression in two
  all_raw_schemas_before_merge = [for m in local.les_info[var.les].microservices :
    { for e in local.les_info[var.les].appEnvironments : "${m}_${e}" =>
      {
        environment : e
        microservice : m
      }
    }
  ]

  # Workaround for bug in 0.12.x - see https://github.com/hashicorp/terraform/issues/22404
  all_raw_schemas = merge(flatten([local.all_raw_schemas_before_merge])...)

  all_schemas = { for k, v in local.all_raw_schemas : replace(lower(k), "-", "_") =>
    {
      schema : replace(lower(k), "-", "_")
      environment : v.environment
      vault_microservice : lower(v.microservice)
    }
  }
  fw_users = { for k, v in local.all_schemas : "${k}_fw" =>
    {
      schema : k
      environment : v.environment
      vault_microservice : v.vault_microservice
      type : "fw"
    }
  }
  rw_users = { for k, v in local.all_schemas : "${k}_rw" =>
    {
      schema : k
      environment : v.environment
      vault_microservice : v.vault_microservice
      type : "rw"
    }
  }
  ro_users = { for k, v in local.all_schemas : "${k}_ro" =>
    {
      schema : k
      environment : v.environment
      vault_microservice : v.vault_microservice
      type : "ro"
    }
  }
  all_users = merge(local.fw_users, local.rw_users, local.ro_users)

  # --------------------------------------------------------------------------------------------------------
  # KMS
  # --------------------------------------------------------------------------------------------------------
  account_id = local.is_production ? "048320708175" : "536342756088"

  kms_administrators_arn = ["arn:aws:iam::${local.account_id}:role/6157-Developer"]


  # --------------------------------------------------------------------------------------------------------
  # SECURITY GROUPS
  # --------------------------------------------------------------------------------------------------------
  operational_lambda_security_group_name = local.is_production ? "6157-operational-lambda-prd-sgr" : "6157-operational-lambda-npr-sgr"
  direct_to_internet_security_group_name = local.is_production ? "6157-internet-prd-sgr" : "6157-internet-npr-sgr"
}