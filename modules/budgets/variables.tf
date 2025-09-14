variable "monthly_budget_name" {
  description = "variable for monthly budget name"
  type        = string
}
variable "emails" {
  description = "list of email where you want to send email"
  type        = list(string)
}
variable "limit_cost" {
  description = "value of limit"
  type        = number
}
variable "limit_cost_currency" {
  description = "the currency of cost"
  type        = string
}
variable "budget_alerts_arn" {
  description = "arn of budget alerts "
  type = string
}
