resource "aws_db_instance" "demo_db" {
  allocated_storage    = 1
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t3.micro"
  identifier           = var.demo_db_identifier
  username             = var.demo_db_username
  password             = var.demo_db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.demo_db_identifier}-${var.project_name}-${var.environment}"
  }
}