variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "api_name" {
  type = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "db_table" {
  description = "Name of the dynamodb table"
  type        = string
}

variable "lambda_role" {
  description = "Name of the lambda execution role"
  type        = string
}

variable "log_retention_in_days" {
  description = "Number of days Logs are retained"
  type        = number
}

variable "aws_region" {
  description = "Region used for the website - us_east_1"
  type        = string
}

variable "vpc_id" {
  description = "Default VPC ID"
  type        = string
}

variable "cloudflare_zone_id" {
  type        = string
}