# Account-level API Gateway CloudWatch Logs role (one per account/region).
#
# API Gateway needs an account-wide IAM role to push execution/access logs to
# CloudWatch. Serverless Framework tries to create this on the first service that
# enables logs, but on a fresh account that create+assign races/fails. Setting it
# here once makes SF's CustomApiGatewayAccountCloudWatchRole a no-op (it sees the
# account already has a role and skips), so there is no drift between the two.

resource "aws_iam_role" "cloudwatch" {
  name = "${var.stage}-${var.prefix}-apigateway-cloudwatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn

  depends_on = [aws_iam_role_policy_attachment.cloudwatch]
}
