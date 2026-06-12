# CloudWatch Log Group with retention
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Function    = var.function_name
  }
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/apigw/${var.rest_api_name}"
  retention_in_days = var.log_retention_in_days

  tags = {
    resource    = var.rest_api_name
  }
}

resource "aws_cloudwatch_log_group" "dynamodb_logs" {
  name              = "/aws/dynamodb/${var.db_table}"
  retention_in_days = var.log_retention_in_days

  tags = {
    resource    = var.db_table
  }
}

resource "aws_cloudwatch_log_group" "cloudfront_distribution_logs" {
  name              = "/aws/cloudfront/website_distribution"
  retention_in_days = var.log_retention_in_days

  tags = {
    resource    = "website_distribution"
  }
}

resource "aws_cloudwatch_dashboard" "cloud_resume" {
  dashboard_name = "cloud-resume-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Invocations & Errors"
          region = aws.us_east_1

          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.counter_function.function_name],
            [".", "Errors", ".", "."]
          ]

          stat = "Sum"
          period = 300
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "API Gateway Requests"

          metrics = [
            [
              "AWS/ApiGateway",
              "Count",
              "ApiName",
              aws_api_gateway_rest_api.counter_api.name
            ]
          ]

          stat = "Sum"
          period = 300
          region = var.aws_region
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "DynamoDB Read/Write Capacity"

          metrics = [
            [
              "AWS/DynamoDB",
              "ConsumedReadCapacityUnits",
              "TableName",
              aws_dynamodb_table.counter_table.name
            ],
            [
              ".",
              "ConsumedWriteCapacityUnits",
              ".",
              "."
            ]
          ]

          stat = "Sum"
          period = 300
          region = var.aws_region
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "CloudFront Requests"

          metrics = [
            [
              "AWS/CloudFront",
              "Requests",
              "DistributionId",
              aws_cloudfront_distribution.website_distribution.id,
              "Region",
              "Global"
            ]
          ]

          stat = "Sum"
          period = 300
          region = "us-east-1"
        }
      }
    ]
  })
}