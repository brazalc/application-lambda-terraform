terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "tech-challenge"

  default_tags {
    tags = {
      app = "tech-challenge"
    }
  }
}
