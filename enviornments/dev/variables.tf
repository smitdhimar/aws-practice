variable "vpc_name" {
  description = "vpc_name"
  type = string
}

variable "environment" {
  description = "environment name"
  type = string
}

variable "app_name" {
  description = "name of the application"
  type = string
}

variable "region" {
  description = "default region"
  type = string
  default = "us-east-1"
} 