variable "vpc_name" {
  description = "vpc_name"
  type        = string
}

variable "private_cidr" {
  description = "list of private_cidr"
  type        = list(string)
}

variable "public_cidr" {
  description = "list of public cidr"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "the cidr of vpc"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}
