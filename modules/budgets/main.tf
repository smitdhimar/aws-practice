resource "aws_budgets_budget" "monthly_cost" {
  name        = var.monthly_budget_name
  budget_type = "COST"
  time_unit   = "MONTHLY"

  limit_amount = var.limit_cost
  limit_unit   = var.limit_cost_currency

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  notification {
    threshold                  = 100
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = var.emails
    subscriber_sns_topic_arns  = [var.budget_alerts_arn]
  }
}
