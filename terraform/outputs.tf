output "api_endpoint" {
  description = "The Invoke URL to put in your frontend JavaScript"
  value       = "${aws_apigatewayv2_api.visitor_counter_api.api_endpoint}/visitors"
}