terraform {
	required_providers {
			aws = {
			source = "hashicorp/aws"
			version = "5.44.0"
		}
	}
}

provider "aws" {
	region = var.region
}

resource "aws_vpc" "my_sandbox_vpc" {
	cidr_block 				= var.vpc_cidr
	enable_dns_support   = true
	enable_dns_hostnames = true
	tags = {
		Name = "MySandboxVPC"
  }
}

resource "aws_subnet" "my_public_subnet" {
	vpc_id            		= aws_vpc.my_sandbox_vpc.id
	cidr_block        		= var.public_subnet_cidr
	availability_zone 		= data.aws_availability_zones.available.names[0]
	map_public_ip_on_launch = true
	tags = {
		Name = "MyPublicSubnet"
	}
}

resource "aws_internet_gateway" "my_igw" {
	vpc_id = aws_vpc.my_sandbox_vpc.id
	tags = {
		Name = "MyIGW"
	}
}

resource "aws_route_table" "my_main_route_table" {
	vpc_id = aws_vpc.my_sandbox_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.my_igw.id
	}

	tags = {
		Name = "MyMainRouteTable"
	}
}

resource "aws_main_route_table_association" "my_main_route_table_association" {
	vpc_id         = aws_vpc.my_sandbox_vpc.id
	# subnet_id      = aws_subnet.my_public_subnet.id
	route_table_id = aws_route_table.my_main_route_table.id
}

resource "aws_security_group" "sandbox_security_group" {
	name        = "SandboxSG"
	description = "Allow web inbound traffic and all outbound"
	vpc_id 		= aws_vpc.my_sandbox_vpc.id

	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = -1
		to_port     = -1
		protocol    = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = 3389
		to_port     = 3389
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
		Name = "SandboxSG"
	}
}

data "aws_availability_zones" "available" {
	state = "available"
}