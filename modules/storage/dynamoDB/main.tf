# AWS iam policy
resource "aws_iam_policy" "aws_iam_policy_for_dynamo_db" {
  name        = "iam_policy_for_dynamo_db"
  description = "Iam policy of Dynamo db access for user data table"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ]
        Resource = [
          "arn:aws:dynamodb:us-east-1:*:table/${var.user_data_table_name}-${var.project_name}-${var.environment}",
          "arn:aws:dynamodb:us-east-1:*:table/*/index/*"
        ]
      }
    ]
  })
}

# AWS iam role 
resource "aws_iam_role" "dynamo_db_iam_role" {
  name = "dynamo_db_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# AWS iam role and policy attachment
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.aws_iam_policy_for_dynamo_db.arn
  role       = aws_iam_role.dynamo_db_iam_role.name
}

# Dynamo db tables

# User data 
# Table
resource "aws_dynamodb_table" "user_data_table" {
  name         = "${var.user_data_table_name}-${var.project_name}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "id"

  attribute {
    name = "name"
    type = "S"
  }
  attribute {
    name = "user_id"
    type = "S"
  }
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "__typename"
    type = "S"
  }
  global_secondary_index {
    name            = "saerch-by-name-index"
    hash_key        = "__typename"
    range_key       = "name"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
  }
}
