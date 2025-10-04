resource "aws_instance" "demo_instance" {
    ami = var.demo_instance_ami
    instance_type = var.demo_instance_type

    tags = {
        Name = "${var.demo_instance_prefix}-${var.project_name}-${var.environment}"
    }
}