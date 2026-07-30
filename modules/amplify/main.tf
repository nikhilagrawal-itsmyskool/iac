# AWS Amplify Hosting app for a git-connected SPA (Vite/React).
#
# Amplify manages the CDN, TLS cert (behind CloudFront) and CI/CD build on push.
# For a custom domain on external DNS (Cloudflare), the domain association stays in
# PENDING_VERIFICATION until you add the emitted DNS records at Cloudflare as
# DNS-only (grey cloud). wait_for_verification = false so terraform never blocks.

resource "aws_amplify_app" "app" {
  name                     = var.app_name
  repository               = var.repository
  access_token             = var.access_token
  platform                 = "WEB"
  enable_branch_auto_build = true
  build_spec               = var.build_spec
  environment_variables    = var.environment_variables

  # SPA rewrite: send all non-asset paths to index.html so client-side routing works.
  # `webmanifest` is in the allow-list so /manifest.webmanifest is served as-is (not
  # rewritten to index.html) — otherwise Chrome can't read the PWA manifest and won't
  # offer install.
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json|webp|webmanifest)$)([^.]+$)/>"
    target = "/index.html"
    status = "200"
  }

  tags = var.tags
}

resource "aws_amplify_branch" "branch" {
  app_id                = aws_amplify_app.app.id
  branch_name           = var.branch_name
  stage                 = var.branch_stage
  enable_auto_build     = true
  environment_variables = var.branch_environment_variables

  tags = var.tags
}

resource "aws_amplify_domain_association" "domain" {
  count       = var.custom_domain == null ? 0 : 1
  app_id      = aws_amplify_app.app.id
  domain_name = var.custom_domain

  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.branch.branch_name
    prefix      = var.subdomain_prefix
  }
}
