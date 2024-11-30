terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "s3" {
    bucket = "daws81s-rs"
    key    = "expense-vpc"
    region = "us-east-1"
    dynamodb_table = "daws81s-remote"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}