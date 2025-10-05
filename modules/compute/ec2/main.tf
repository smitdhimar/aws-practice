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

# security groups
resource "aws_security_group" "ec2_security_group" {
  name        = "demo-instance-sg-${var.project_name}-${var.environment}"
  description = "security group for aws ec2"

  # inbound rules
  ingress {
    description = "to allow http request on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "to allow https requests on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "to allow http connection from local ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.ip.response_body)}/32"]
  }
  # outbound rules
  egress {
    description = "all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # tags
  tags = {
    Name = "demo-instance-sg-${var.project_name}-${var.environment}"
  }
}

# instances
# demo instance 
resource "aws_instance" "demo_instance" {
  ami                    = var.demo_instance_ami
  instance_type          = var.demo_instance_type
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = "${var.demo_instance_prefix}-${var.project_name}-${var.environment}"
  }
}

#instance state
resource "aws_ec2_instance_state" "demo_instance_state" {
  instance_id = aws_instance.demo_instance.id
  state       = "running"
}