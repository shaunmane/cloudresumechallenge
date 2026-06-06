variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
  default = "shaunmane.com"
}

variable "bucket_name" {
  type = string
  default = "mywebsite"
}

variable "rest_api_name" {
  type = string
}

variable "rest_api_path" {
  type =string
  default = "/"
}

variable "counter_api_stage_name" {
  type = string
}