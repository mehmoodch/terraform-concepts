variable "region" {
    description = "Aws provider region"
    type = string
    default = "us-east-1"  
}
variable "vpc_cidr" {
    description = "CIDR block for vpc"
    type = string
    default = "10.0.0.0/16"
}
variable "public_subnets" {
    description = "public subnets for vpc"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets" {
    description = "private subnets for vpc"
    type = list(string)
    default = [ "10.0.3.0/24", "10.0.4.0/24" ]  
}
variable "availability_zones" {
    description = "region vise availablity zones"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ] 
}
variable "instance_type" {
    description = "instance type for ec2"
    type = string
    default = "t2.micro"
}
variable "ami_id" {
    description = "ami for ec2"
    type = string
    default = "ami-04a81a99f5ec58529"  
}
variable "key_name" {
    description = "key value pair"
    type = string
    default = "test"
}
