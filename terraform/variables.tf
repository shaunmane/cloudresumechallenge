variable "cloudflare_api_token" {
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

variable "rest_api_path" {
  type    = string
  default = "/"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "counter_function"
}

variable "db_table" {
  type    = string
  default = "site-visitor-counter"
}