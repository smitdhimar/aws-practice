# gateway
resource "aws_apigatewayv2_api" "http_api" {
  name = "http_api_gateway"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = [ "*" ]
    allow_origins = [ "*" ]
    allow_methods = [ "GET", "POST", "PUT", "DELETE", "OPTIONS"]
    expose_headers = [ "*"]
    max_age = 3600
  }
}

# stage name 
resource "aws_apigatewayv2_stage" "stage" {
    api_id = aws_apigatewayv2_api.http_api.id
    name = var.environment
    auto_deploy = true
}

# lambda permissions 
resource "aws_lambda_permission" "allow_api_gateway_lambda_invokation" {
    for_each = var.lambda_functions_map

    statement_id = "AllowApiGatewayInvoke-${each.key}"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    function_name = each.key

    source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}