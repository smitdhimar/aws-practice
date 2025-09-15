provider "aws" {
  region = var.region
}

# module "vpc" {
#   source = "../../modules/network/vpc"

#   vpc_name = var.vpc_name
#   vpc_cidr = var.vpc_cidr
#   public_cidr = var.public_cidr
#   private_cidr = var.private_cidr
#   project_name = var.project_name
#   environment = var.environment
# }

module "sns" {
  source = "../../modules/miscellaneous_services/sns"
}

module "budgets" {
  # source
  source = "../../modules/billing_cost_budget/budgets"

  # variables 
  monthly_budget_name = var.monthly_budget_name
  emails              = var.emails
  limit_cost          = var.limit_cost
  limit_cost_currency = var.limit_cost_currency
  budget_alerts_arn   = module.sns.budget_alerts_arn
}