# Shared execution role for all core-api Lambda functions.
#
# Serverless Framework's default is one generated role per service, whose inline
# policy lists a CloudWatch Logs resource ARN per function. Modules with many
# functions (library, timetable) exceed IAM's 10 KB inline-policy limit. Pointing
# every service at this single shared role (provider.iam.role) removes the
# per-function policy generation entirely.

resource "aws_iam_role" "lambda" {
  name = "${var.stage}-${var.prefix}-lambda-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.stage}-${var.prefix}-lambda-execution"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:TagResource",
        ]
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:*"
      },
      {
        Effect   = "Allow"
        Action   = ["SNS:Publish", "s3:PutObject", "s3:GetObject", "s3:PutObjectAcl", "s3:DeleteObject"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["SQS:SendMessage"]
        Resource = "*"
      },
    ]
  })
}
