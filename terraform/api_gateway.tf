# ─────────────────────────────────────────────
# API Gateway
# ─────────────────────────────────────────────
# HTTP API Gateway
resource "aws_apigatewayv2_api" "visitor_counter_api" {
  name          = var.api_name
  protocol_type = "HTTP"

  # Configure CORS so your frontend can call this endpoint
  cors_configuration {
    allow_origins = ["https://shaunmane.com"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 300
  }
}

# $default Stage (Auto-deploys changes immediately)
resource "aws_apigatewayv2_stage" "counter_stage" {
  api_id      = aws_apigatewayv2_api.visitor_counter_api.id
  name        = "$default"
  auto_deploy = true
}

# Integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.visitor_counter_api.id
  integration_type = "AWS_PROXY"

  integration_uri        = aws_lambda_function.counter_function.arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# GET /visitors Route
resource "aws_apigatewayv2_route" "get_visitors_route" {
  api_id    = aws_apigatewayv2_api.visitor_counter_api.id
  route_key = "GET /visitors"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
