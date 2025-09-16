output "layers_arn"{
    description = "the map of layres name and arn"
    value = { for name, layer in aws_lambda_layer_version.layers : name => layer.arn}
}