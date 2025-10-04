output "ec2_public_ip"{
    value = aws_instance.demo_instance.public_ip
}