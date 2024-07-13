resource "aws_instance" "web" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = var.size
   depends_on = [ aws_s3_bucket.terraform-Concepts-s3-bucket ]

  tags = {
    Name = "Terraform Concepts"
  }
 
}
resource "aws_s3_bucket" "terraform-Concepts-s3-bucket" {
    bucket = "terraform-Concepts-s3-bucket"
}
 