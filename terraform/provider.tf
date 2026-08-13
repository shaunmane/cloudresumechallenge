terraform {
  required_version = "> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 6.55.0"
    }
    random = {
      source = "hashicorp/random"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.22"
    }
  }

  backend "s3" {
    bucket       = "portfolio-website-tf-state"
    key          = "portfolio/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}