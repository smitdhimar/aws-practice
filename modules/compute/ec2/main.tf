# GET ip address
data "http" "ip" {
  url = "http://checkip.amazonaws.com"
}

# key pairs
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = tls_private_key.my_key.public_key_openssh
}
resource "local_file" "ec2_pem_keys" {
  content         = tls_private_key.my_key.private_key_pem
  file_permission = "0400"
  filename        = "${path.module}/ec2_pem_keys.pem"
}

# instances
# demo instance 
resource "aws_instance" "demo_instance" {
  ami                    = var.demo_instance_ami
  instance_type          = var.demo_instance_type
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = "${var.demo_instance_prefix}-${var.project_name}-${var.environment}"
  }
}

#instance state
resource "aws_ec2_instance_state" "demo_instance_state" {
  instance_id = aws_instance.demo_instance.id
  state       = var.demo_instance_state
}