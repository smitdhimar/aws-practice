# Create VPC
resource "aws_vpc" "vpc_main" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr

  tags = {
    Name        = "${var.vpc_name}-${var.project_name}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name        = "igw-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

# Create public and private subnets 
resource "aws_subnet" "public_subnet" {
  for_each = toset(var.public_cidr)
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = each.key

  tags = {
    Name = "public-subnet-${each.key}-${var.project_name}-${var.environment}"
    environment = var.environment
    project = var.project_name
  }
}
resource "aws_subnet" "private_subnet" {
  for_each = toset(var.private_cidr)
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = each.key

  tags = {
    Name = "private-subnet-${each.key}-${var.project_name}-${var.environment}"
    environment = var.environment
    project = var.project_name
  }
  
}

#route table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  } 
  tags = {
    Name = "public-route-table-${var.project_name}-${var.environment}"
    environment = var.environment
    project = var.project_name
  }
}

# association with public ips 
resource "aws_route_table_association" "route_table_association" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}