terraform {
  required_version = "> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 6.15.0"
    }
    random = {
      source = "hashicorp/random"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "portfolio-tf-state"
    key          = "portfolio/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}