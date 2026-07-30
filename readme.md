terragrunt backend bootstrap
terragrunt init --upgrade

export AWS_PROFILE=prod-itsmyskool-nikhil.agrawal
aws sts get-caller-identity
cd /mnt/h/github/itsmyskool/iac/live/prod/network
terragrunt backend bootstrap
cd /mnt/h/github/itsmyskool/iac/live/prod
terragrunt run-all apply
export AMPLIFY_GITHUB_TOKEN=ghp_something


aws apigateway get-domain-name --domain-name api-prod.itsmyskool.com --profile prod-itsmyskool-nikhil.agrawal --region ap-south-1 --query 'regionalDomainName' --output text