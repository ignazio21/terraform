provider "aws" {
  region     = "${var.aws_region}"
}

# Create a VPC
resource "aws_vpc" "tf_vpc" {
	cidr_block = "172.16.0.0/16"
}

# Create an Internet Gateway and assign to VPC
resource "aws_internet_gateway" "tf_igw_vpc" {
	vpc_id = "${aws_vpc.tf_vpc.id}"
}

# Create a subnet 
resource "aws_subnet" "tf_subnet" {
	vpc_id = "${aws_vpc.tf_vpc.id}"
	cidr_block = "172.16.1.0/24"
	map_public_ip_on_launch = true
}

# Create a Security Group
resource "aws_security_group" "tf_sg" {
	name = "tf_sg"
	description = "created from terraform"
	vpc_id = "${aws_vpc.tf_vpc.id}"

	#SSH access
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	#HTTP
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	#Outbound internet access
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Key Pair
#resource "aws_key_pair" "auth" {
#	key_name = "${var.key_name}"
#	key_path = "${file(var.public_key_path)}"
#}

#Public Instance
resource "aws_instance" "tf_dck_swam_mngr" {
	#connection {
	#	user = "ec2-user"
	#}

	ami           			= "${lookup(var.aws_amis,var.aws_region)}"
	instance_type 			= "t2.micro"
	#key_name 				= "${aws_key_pair.auth.id}"
	vpc_security_group_ids	= ["${aws_security_group.tf_sg.id}"]
	subnet_id 				= "${aws_subnet.tf_subnet.id}"

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo yum install -y nginx",
			"sudo systemctl start nginx",
		]
	}
}