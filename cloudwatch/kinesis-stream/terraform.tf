terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.8.1"
    }
  }
}