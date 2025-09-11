variable "vpc_name" {
  description = "vpc_name"
  type = string
}

variable "environment" {
  description = "environment name"
  type = string
}

variable "project_name" {
  description = "name of the project"
  type = string
}

variable "region" {
  description = "default region"
  type = string
  default = "us-east-1"
} 

variable "private_cidr" {
  description = "list of private CIDRs"
  type = list(string)
}
variable "public_cidr" {
  description = "list of public CIDRs"
  type = list(string)
}

variable "vpc_cidr" {
  description = "the cidr of vpc"
  type = string
}