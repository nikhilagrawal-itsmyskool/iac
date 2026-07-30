output "cloudwatch_role_arn" {
  description = "ARN of the account-level API Gateway CloudWatch Logs role"
  value       = aws_iam_role.cloudwatch.arn
}
