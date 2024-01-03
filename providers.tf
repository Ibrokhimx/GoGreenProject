terraform {
  cloud {
    organization = "pitt412"

    workspaces {
      name = "GoGreen_project"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}