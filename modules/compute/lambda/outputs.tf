data "aws_lambda_functions" "all" {}
data "aws_lambda_function" "details"{
  count = length(data.aws_lambda_functions.all.function_names)
  function_name = data.aws_lambda_functions.all.function_names[count.index]
}
output "layers_arn" {
  description = "the map of layres name and arn"
  value       = { for name, layer in aws_lambda_layer_version.layers : name => layer.arn }
}
output "lambda_functions_map" {
  description = "list of lambda functions declared with invoke arns"
  value = { for i,function_name in data.aws_lambda_functions.all.function_names : 
    function_name => {
        arn = data.aws_lambda_functions.all.function_arns[i]
        invoke_arn = data.aws_lambda_function.details[i].invoke_arn
    } 
  }
}