output "budget_alerts_arn" {
  description = "arn of the budget_alerts resource"
  value = aws_sns_topic.budget_alerts.arn
}