resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_tls.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = data.cloudflare_zone.main.zone_id

  name    = each.value.name
  content = each.value.value
  type    = each.value.type
  ttl     = 60
  proxied = false
}

resource "cloudflare_dns_record" "root" {
  zone_id = data.cloudflare_zone.main.zone_id

  name    = "@"
  type    = "CNAME"
  content = aws_cloudfront_distribution.website_distribution.domain_name

  proxied = false
}

resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.main.zone_id

  name    = "www"
  type    = "CNAME"
  content = aws_cloudfront_distribution.website_distribution.domain_name

  proxied = false
}