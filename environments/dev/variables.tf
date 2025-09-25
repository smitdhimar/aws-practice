# Globals
# ___________________________________________________________
variable "environment" {
  description = "environment name"
  type        = string
}

variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "region" {
  description = "default region"
  type        = string
  default     = "us-east-1"
}

# VPC
# ___________________________________________________________
variable "vpc_name" {
  description = "vpc_name"
  type        = string
}
variable "private_cidr" {
  description = "list of private CIDRs"
  type        = list(string)
}
variable "public_cidr" {
  description = "list of public CIDRs"
  type        = list(string)
}
variable "vpc_cidr" {
  description = "the cidr of vpc"
  type        = string
}

# Budgets
# ___________________________________________________________

variable "monthly_budget_name" {
  description = "Variable for monthly budget name"
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

# lambda
# ___________________________________________________________
variable "crud_handler_name" {
  description = "the name of the crud handler"
  type        = string
}
variable "runtime" {
  description = "the runtime , either java or node js "
  type        = string
}
