# apigateway-account

Sets the account-level API Gateway CloudWatch Logs role (one per account/region).

Required before any API Gateway stage can emit execution/access logs. On a fresh
account, provisioning this once here avoids the race/failure in Serverless
Framework's `CustomApiGatewayAccountCloudWatchRole` custom resource — with the
account role already assigned, that custom resource becomes a no-op.

Apply once per prod account. Note: `aws_api_gateway_account` may need a re-apply if
the IAM role hasn't propagated yet on the very first run.
