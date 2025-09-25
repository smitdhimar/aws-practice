variable "lambda_functions_map" {
  description = "lambda map with name and other properties"
  type = map(object({
    arn         = string
    invoke_arn  = string
  }))
}

variable "project_name" {
  description = "name of project"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "crud_handler_name" {
  description = "name of crud handler"
  type        = string
}
