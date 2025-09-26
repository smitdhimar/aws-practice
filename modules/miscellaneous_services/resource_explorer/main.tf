resource "aws_resourceexplorer2_index" "aggregator" {
    type = "AGGREGATOR"

    tags = {
      created_by = "Terraform_iaas_user_Smit"
      purpose = "resource_exploration"
    }
}

resource "aws_resourceexplorer2_view" "view" {
  name = "basic-view"

  included_property {
    name = "tags"
  }

  default_view = true
  depends_on = [ aws_resourceexplorer2_index.aggregator ]
}