variable "size" {
    type = string
    default = "t2.micro"
    description = "ec2 instance size"  
}
# Attribute Reference - Create Public DNS URL with http:// appended
output "privateip" {
  description = "Private ip of an EC2 Instance"
  value = aws_instance.web.private_ip
}