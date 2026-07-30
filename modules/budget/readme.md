# budget

Creates a monthly AWS **cost** budget (`aws_budgets_budget`) with email alerts.

AWS Budgets is a global service, so this works with the account's default
provider regardless of region.

## Inputs
| Name                    | Description                                      | Default    |
|-------------------------|--------------------------------------------------|------------|
| `limit_amount`          | Monthly budget limit in USD                      | `"20"`     |
| `notification_emails`   | Email addresses that receive alerts (required)   | —          |
| `actual_thresholds`     | % thresholds for ACTUAL-spend alerts             | `[80,100]` |
| `forecasted_thresholds` | % thresholds for FORECASTED-spend alerts         | `[100]`    |

## Notes
- Each email subscriber gets a confirmation-free budget notification (no SNS
  topic needed).
- Alerts fire once per threshold crossing per period.
