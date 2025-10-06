# get ip address
data "http" "ip" {
  url = "http://checkip.amazonaws.com"
}

# Define security group configurations in locals
locals {
  security_group_configs = {
    ec2 = {
      name        = "${var.demo_instance_prefix}-sg-${var.project_name}-${var.environment}"
      description = "Security group for web servers"
      rules = {
        ingress = {
          http = {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }
          https = {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }
          ssh = {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["${chomp(data.http.ip.response_body)}/32"]
          }
        }
        egress = {
          all = {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
        }
      }
    }
    rds = {
      name        = "${var.demo_db_identifier}-sg-${var.project_name}-${var.environment}"
      description = "Security group for application servers"
      rules = {
        ingress = {
          app_port = {
            from_port   = 3306
            to_port     = 3306
            protocol    = "tcp"
            cidr_blocks = ["${chomp(data.http.ip.response_body)}/32"]
          }
        }
        egress = {
          all = {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
        }
      }
    }
  }
}


# dynamic security groups
resource "aws_security_group" "security_group" {
  for_each = local.security_group_configs
  name        = each.value.name
  description = each.value.description

  dynamic "ingress" {
    for_each = each.value.rules.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.rules.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}