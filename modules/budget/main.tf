resource "aws_budgets_budget" "monthly_cost" {
  name         = "${var.stage}-${var.method}-${var.prefix}-monthly-cost"
  budget_type  = "COST"
  limit_amount = var.limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  # Alert on actual spend crossing each threshold percentage, plus a
  # forecast-based alert so we hear about an overrun before it happens.
  dynamic "notification" {
    for_each = var.actual_thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = var.notification_emails
    }
  }

  dynamic "notification" {
    for_each = var.forecasted_thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = var.notification_emails
    }
  }
}
