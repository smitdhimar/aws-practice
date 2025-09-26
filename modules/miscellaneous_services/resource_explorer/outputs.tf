# index as output
output "explorer_index" {
    description = "output of explorer index"
    value = aws_resourceexplorer2_index.aggregator
}