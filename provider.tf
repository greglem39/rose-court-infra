terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region-va
}

# provider "aws" {
#   region = var.region-cali
#   alias  = "aws-cali"
# }
