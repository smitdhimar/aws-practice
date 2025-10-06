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

# sns
module "sns" {
  # source
  source = "../../modules/miscellaneous_services/sns"
}
# budget
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
# # lambda functions
# module "lambda" {
#   # source
#   source = "../../modules/compute/lambda"

#   # variables
#   crud_handler_name  = var.crud_handler_name
#   environment        = var.environment
#   project_name       = var.project_name
#   runtime            = var.runtime
#   region             = var.region
#   user_table_name    = "${var.user_data_table_name}-${var.project_name}-${var.environment}"
#   dynamo_db_iam_role = module.dynamoDB.dynamo_db_iam_role
# }
# # dynamo db
# module "dynamoDB" {
#   # source
#   source = "../../modules/storage/dynamoDB"

#   # variables
#   environment          = var.environment
#   project_name         = var.project_name
#   user_data_table_name = var.user_data_table_name
# }
# # api gateway
# module "api_gateway" {
#   # source
#   source = "../../modules/miscellaneous_services/api_gateway"

#   # variables
#   environment          = var.environment
#   project_name         = var.project_name
#   lambda_functions_map = module.lambda.lambda_functions_map
#   crud_handler_name    = var.crud_handler_name
# }
# resource explorer
module "resource_exporer" {
  # source
  source = "../../modules/miscellaneous_services/resource_explorer"

  # variable
}

#EC2 instaces
module "ec2" {
  # source 
  source = "../../modules/compute/ec2"

  # variables
  #globals
  environment = var.environment
  project_name = var.project_name
  #demo instance
  demo_instance_ami    = var.demo_instance_ami
  demo_instance_prefix = var.demo_instance_prefix
  demo_instance_type   = var.demo_instance_type
  security_group_id    = module.security_groups.security_groups["ec2"].id
}

# RDS 
module "rds" {
  #source
  source = "../../modules/storage/rds"

  # variables
  demo_db_identifier = var.demo_db_identifier
  demo_db_username   = var.demo_db_username
  demo_db_password   = var.demo_db_password
  environment        = var.environment
  project_name       = var.project_name
  security_group_id  = module.security_groups.security_groups["rds"].id
}

module "security_groups" {
  # sources
  source = "../../modules/network/security_groups"

  # variables
  demo_db_identifier = var.demo_db_identifier
  project_name         = var.project_name
  environment          = var.environment
  demo_instance_prefix = var.demo_instance_prefix
}
