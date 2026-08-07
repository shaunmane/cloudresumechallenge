resource "aws_api_gateway_rest_api" "counter_api" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.rest_api_name
      version = "1.0"
    }
    paths = {
      (var.rest_api_path) = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = aws_lambda_function.counter_function.invoke_arn
          }
        }
      }
    }
  })

  name = var.rest_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "counter_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.counter_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.counter_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "counter_api_stage" {
  deployment_id = aws_api_gateway_deployment.counter_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.counter_api.id
  stage_name    = var.counter_api_stage_name
}