provider "aws" {
  region = local.region
}

provider "aws" {
  region = local.region_dr
  alias  = "dr"
}

locals {
  region    = "ca-central-1"
  region_dr = "eu-west-1"
}

resource "aws_s3_bucket_object" "source_code_move_file" {
  key                    = "src/splunk/splunk.zip"
  bucket                 = var.bucket
  source                 = "./src/splunk/splunk.zip"
  source_hash            = filemd5("./src/splunk/splunk.zip")
  server_side_encryption = "aws:kms"
  tags                   = var.tags
}

resource "aws_s3_bucket_object" "source_code_move_file_dr" {
  provider               = aws.dr
  key                    = "src/splunk/splunk.zip"
  bucket                 = "${var.bucket}-dr"
  source                 = "./src/splunk/splunk.zip"
  source_hash            = filemd5("./src/splunk/splunk.zip")
  server_side_encryption = "aws:kms"
  tags                   = var.tags
}