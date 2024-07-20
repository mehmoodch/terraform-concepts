output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.terraform-test-vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public-subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private-subnet[*].id
}

output "public_instance_id" {
  description = "The ID of the public instance"
  value       = aws_instance.public_instance.id
}

output "private_instance_id" {
  description = "The ID of the private instance"
  value       = aws_instance.private_instance.id
}
