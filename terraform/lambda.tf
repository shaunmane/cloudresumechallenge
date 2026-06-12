resource "aws_lambda_function" "counter_function" {
  filename      = "function.zip"
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  memory_size   = 512
  timeout       = 30

  # Advanced logging configuration
  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }

  # Ensure IAM role and log group are ready
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_logs
  ]
}
