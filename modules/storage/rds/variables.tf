# global
variable "environment" {
  description = "environment name"
  type        = string
}
variable "project_name" {
  description = "name of the project"
  type        = string
}
# demo db
variable "demo_db_identifier" {
  description = "demo db identifier"
  type = string
}
variable "demo_db_username" {
  description = "demo database username"
  type = string
}
variable "demo_db_password" {
  description = "demo database password"
  type = string
}
# security group id
variable "security_group_id" {
  description = "The id of the security group"
  type        = string
}