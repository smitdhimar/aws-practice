variable "crud_handler_name" {
  description = "Name of crud handler"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}
variable "region" {
  description = "region"
  type        = string
}

variable "project_name" {
  description = "name of the project"
  type        = string
}
variable "runtime" {
  description = "the runtime"
  type        = string
  validation {
    condition     = contains(["nodejs18.x", "java21"], var.runtime)
    error_message = "runtime must be 'nodejs18.x' or 'java21'"
  }
}
variable "user_table_name" {
  description = "user table name"
  type        = string
}
variable "dynamo_db_iam_role" {
  description = "arn of iam role for executing dynamo db"
  type = object({
    name = string
    arn  = string
  })
}