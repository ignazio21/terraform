provider "aws" {
  region     = "eu-west-1"
}

#Public Subnet
resource "aws_instance" "tf_dck_swam_mngr" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  subnet_id 	= "subnet-8aed40d1"
}

#Private Subnet
resource "aws_instance" "tf_dck_swarm_nd" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  subnet_id 	= "subnet-8e6405e9"
}

#Interpolation
resource "aws_eip" "ip" {
	instance = "${aws_instance.tf_dck_swam_mngr.id}"
}

