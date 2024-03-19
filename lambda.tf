// create the lambda function from zip file
resource "aws_lambda_function" "function" {
  function_name = "tech-challenge-auth"
  description   = "Tech Challenge Auth Lambda Function"
  role          = aws_iam_role.lambda.arn
  handler       = "fiap.com.lambda.LambdaHandler::handleRequest"
  memory_size   = 128
  timeout = 30

  s3_bucket = "tech-challenge-lambda-s3"
  s3_key    = "function.zip"

  runtime = "java17"
}

// create log group in cloudwatch to gather logs of our lambda function
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 7
}
