provider "aws" {
  region     = "eu-west-1"
}

resource "aws_instance" "tf_instance" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  subnet_id 	= "subnet-8e6405e9"
}
