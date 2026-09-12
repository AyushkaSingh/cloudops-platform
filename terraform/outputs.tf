output "vpc_id" {
  description = "ID of the CloudOps VPC"
  value       = aws_vpc.cloudops_vpc.id
}

output "ec2_instance_id" {
  description = "ID of the CloudOps EC2 instance"
  value       = aws_instance.cloudops_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of the CloudOps EC2 instance"
  value       = aws_instance.cloudops_ec2.public_ip
}