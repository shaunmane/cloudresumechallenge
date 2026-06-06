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