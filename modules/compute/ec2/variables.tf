#global
variable "project_name" {
  description = "projectname"
  type        = string
}
variable "environment" {
  description = "environment"
  type        = string
}
#demo instance
variable "demo_instance_ami" {
  description = "The ami of demo instance"
  type        = string
}
variable "demo_instance_prefix" {
  description = "The prefix(name) of demo instance"
  type        = string
}
variable "demo_instance_type" {
  description = "The instance type of demo instance "
  type        = string
}
