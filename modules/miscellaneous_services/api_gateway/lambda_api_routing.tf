locals {
  lambda_with_mappings = {
    "crud_handler" = {
      routes = [
        {
          route        = "/crud/health"
          http_method  = "GET"
          is_protected = "false"
        },
        {
          route        = "/crud/user/{id}"
          http_method  = "GET"
          is_protected = "false"
        }
      ]
    }
  }

  # flat_routes as a set of objects, each with route, http_method, is_protected, and handler_name
  #example output
  # flat routes = {
  #   "crud_handler_GET_health" {
  #     route = "/health"
  #     handler = "crud_handler"
  #     http_method = "GET"
  #     is_protected = true
  #   }
  # }
  flat_routes = {
    for p in flatten([
      for handler_name, handler_obj in local.lambda_with_mappings : [
        for route in handler_obj.routes : {
          key = "${handler_name}_${route.http_method}${replace(route.route, "/", "_")}"
          value = {
            route        = route.route
            handler      = handler_name
            http_method  = route.http_method
            is_protected = route.is_protected
          }
        }
      ]
    ]) :
    p.key => p.value
  }

}


resource "aws_apigatewayv2_integration" "lambda_integrations" {
  for_each = local.lambda_with_mappings

  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.lambda_functions_map["${each.key}-${var.project_name}-${var.environment}"].invoke_arn
}

resource "aws_apigatewayv2_route" "routes" {
  for_each   = local.flat_routes
  api_id     = aws_apigatewayv2_api.http_api.id
  route_key  = "${each.value.http_method} ${each.value.route}"
  target     = "integrations/${aws_apigatewayv2_integration.lambda_integrations[each.value.handler].id}"
  depends_on = [aws_apigatewayv2_integration.lambda_integrations]
}
