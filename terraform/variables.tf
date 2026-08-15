variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Website name"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket with portforlio website"
  type        = string
}

variable "api_name" {
  description = "Name of HTTP API in API Gateway"
  type        = string
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
  description = "Region used for the website"
  type        = string
  default     = "us-east-1"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID from domain overview"
  type        = string
}