# lambda-execution-role

A single shared IAM execution role for all core-api Lambda functions.

Referenced from the Serverless config via `provider.iam.role` so Serverless does not
generate a per-service role (whose per-function inline policy exceeds IAM's 10 KB
limit on modules with many functions).

Grants: CloudWatch Logs (scoped to the region/account), SNS:Publish, S3 get/put,
SQS:SendMessage — mirroring the previous `iamRoleStatements`.

Role name: `${stage}-${prefix}-lambda-execution` (e.g. `prod-itsmyskool-lambda-execution`).
