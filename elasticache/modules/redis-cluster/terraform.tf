terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.26.0"
      configuration_aliases = [aws.dr_aws]
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.8.2"
    }
  }
}