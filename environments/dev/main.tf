provider "aws" {
  region = var.region
}

# module "vpc" {
# source
#   source = "../../modules/network/vpc"

# variables
#   vpc_name = var.vpc_name
#   vpc_cidr = var.vpc_cidr
#   public_cidr = var.public_cidr
#   private_cidr = var.private_cidr
#   project_name = var.project_name
#   environment = var.environment
# }

module "sns" {
  # source
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

module "lambda" {
  # source
  source = "../../modules/compute/lambda"

  # variables
  crud_handler_name = var.crud_handler_name
  environment       = var.environment
  project_name      = var.project_name
  runtime           = var.runtime
}

# module "dynamoDB" {
#   # source
#   source = "../../modules/storage/dynamoDB"

#   # variables

# }

# module "api_gateway" {
#   # source
#   source = "../../modules/miscellaneous_services/api_gateway"

#   # variables

# }
