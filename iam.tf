// allow lambda service to assume (use) the role with such policy
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// create lambda role, that lambda function can assume (use)
resource "aws_iam_role" "lambda" {
  name               = "AssumeLambdaRole"
  description        = "Role for lambda to assume lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

// Policy document for S3 access
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::tech-challenge-fiap", "arn:aws:s3:::tech-challenge-fiap/*"]
  }
}

// create a policy for S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy for S3 bucket access"
  policy      = data.aws_iam_policy_document.s3_access_policy.json
}

// attach S3 access policy to the Lambda role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

// Policy document for lambda logging
data "aws_iam_policy_document" "allow_lambda_logging" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

// create a policy to allow writing into logs and create logs stream
resource "aws_iam_policy" "function_logging_policy" {
  name        = "AllowLambdaLoggingPolicy"
  description = "Policy for lambda cloudwatch logging"
  policy      = data.aws_iam_policy_document.allow_lambda_logging.json
}

// attach policy to out created lambda role
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}
