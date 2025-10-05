output "ssh_command"{
    value = "ssh -i modules/compute/ec2/ec2_pem_keys.pem ec2-user@ec2-${replace(aws_instance.demo_instance.public_ip,".","-")}.compute-1.amazonaws.com"
}