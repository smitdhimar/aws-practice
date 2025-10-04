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

# security groups


# instances
# demo instance 
resource "aws_instance" "demo_instance" {
  ami           = var.demo_instance_ami
  instance_type = var.demo_instance_type

  tags = {
    Name = "${var.demo_instance_prefix}-${var.project_name}-${var.environment}"
  }
}
