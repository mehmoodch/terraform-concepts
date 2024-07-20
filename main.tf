provider "aws" {
  region = var.region
}

resource "aws_vpc" "terraform-test-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "terraform-test-vpc"
  }  
}

resource "aws_subnet" "public-subnet" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.terraform-test-vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.terraform-test-vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }  
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.terraform-test-vpc.id
  tags = {
    Name = "ig"
  }
}

resource "aws_network_interface" "testing" {
  subnet_id = aws_subnet.public-subnet[0].id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.terraform-test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public-subnet)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.terraform-test-vpc.id
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private-subnet)
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_security_group" "public-sg" {
  vpc_id = aws_vpc.terraform-test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "private-sg" {
  vpc_id = aws_vpc.terraform-test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.public-subnet.*.id, 0)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.public-sg.id]

  tags = {
    Name = "public-instance1"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private-subnet.*.id, 0)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.private-sg.id]

  tags = {
    Name = "private-instance1"
  }
}