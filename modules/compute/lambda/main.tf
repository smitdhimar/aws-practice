# locals
locals {
  lambda_functions = [var.crud_handler_name]
  layers           = ["common_helper_functions"]
}

# Function archive
data "archive_file" "archive_lambdas" {
  for_each = toset(local.lambda_functions)

  type        = "zip"
  source_dir  = "${path.module}/functions/${each.key}"
  output_path = "${path.module}/function/${each.key}.zip"
  excludes    = ["**/*.zip"]
}

# Layers archive
data "archive_file" "arhive_layers" {
  for_each = toset(local.layers)

  type        = "zip"
  source_dir  = "${path.module}/layers/${each.key}"
  output_path = "${path.module}/layers/${each.key}.zip"
  excludes    = ["**/*.zip"]
}

# lambda funcitons 
# The Iam role, policy is declared at the function level to maintain the best practices of least privileges.

# crud handler 
# function
resource "aws_lambda_function" "crud_handler" {
  function_name    = "${var.crud_handler_name}-${var.project_name}-${var.environment}"
  handler          = var.runtime == "java21" ? "com.example.Handler::handleRequest" : "index.handler"
  role             = aws_iam_role.lambda_handler_execution_role.arn
  runtime          = var.runtime
  filename         = data.archive_file.archive_lambdas[var.crud_handler_name].output_path
  timeout          = 180
  publish          = true
  source_code_hash = data.archive_file.archive_lambdas[var.crud_handler_name].output_base64sha256
  skip_destroy     = false

  # layers that the lambda function depends on
  layers     = [aws_lambda_layer_version.layers["common_helper_functions"].arn]
  depends_on = [aws_lambda_layer_version.layers["common_helper_functions"]]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {

    }
  }
}
# role execution
resource "aws_iam_role" "lambda_handler_execution_role" {
  name = "lambda_handler_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}
# iam policy 
resource "aws_iam_policy" "lambda_handler_iam_policy" {
  name        = "lambda_handler_iam_policy"
  path        = "/"
  description = "The lambda crud handler iam policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "lambda:GetLayerVersion"
        ]
        Resource = [
          "arn:aws:logs:*:*:*",
          "arn:aws:lambda:*:*:layer:common_helper_functions:*"
        ]
        Effect = "Allow"
      }
    ]

  })
}
# policy attachment
resource "aws_iam_role_policy_attachment" "lambda_default_policy_attachment" {
  role       = aws_iam_role.lambda_handler_execution_role.name
  policy_arn = aws_iam_policy.lambda_handler_iam_policy.arn
}

# Layers
resource "aws_lambda_layer_version" "layers" {
  for_each = toset(local.layers)

  layer_name          = each.key
  filename            = data.archive_file.arhive_layers[each.key].output_path
  source_code_hash    = data.archive_file.arhive_layers[each.key].output_base64sha256
  compatible_runtimes = ["nodejs20.x"]
  skip_destroy        = false # removes the zip file from the folder structure once the deployment is complete
}
