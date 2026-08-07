# ─────────────────────────────────────────────
# Lambda
# ─────────────────────────────────────────────
# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAssumeRole",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "dynamodb.amazonaws.com"
          ]
        }
      }
    ]
  })
}

# Policy for running lambda
resource "aws_iam_policy" "execution_policy" {
  name        = "aws_iam_policy_for_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
    {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid": "AllowLambda",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : "arn:aws:lambda:*:*:function:*"
      },
      {
        "Sid": "AllowDynamoDB",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/*"
      },
      {
        "Sid": "AllowCloudWatch",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      }
    ]
  }
  EOF
}

# Attach logging policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
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

# ─────────────────────────────────────────────
# CloudFront
# ─────────────────────────────────────────────