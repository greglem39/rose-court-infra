terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
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
