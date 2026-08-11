# ─────────────────────────────────────────────
# Lambda
# ─────────────────────────────────────────────
# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# ─────────────────────────────────────────────
# API Gateway
# ─────────────────────────────────────────────
# API Gateway to invoke lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.counter_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.counter_api.execution_arn}/*/*"
}
