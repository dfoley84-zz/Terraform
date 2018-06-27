provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# ---------- S3 Bucket -----------------
resource "random_id" "bucket_id" {
  byte_length = 3
}

resource "aws_s3_bucket" "S3 Bucket" {
  bucket        = "${var.apache_bucket_name}-${random_id.bucket_id.dec}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "S3 Apache Bucket"
  }
}

# ---------- AWS VPC ------------------

data "aws_availability_zone" "vpc_zone" {}

# Creating VPC for Apache Deployment 
resource "aws_vpc" "Apache_vpc" {
  cidr_block           = "213.127.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "Apache Deployment"
  }
}

# Gateway for public subnet
resource "aws_internet_gateway" "Apache_Internet_gateway" {
  vpc_id = "${aws_vpc.Apache_vpc.id}"

  tags {
    Name = "Apache_igw"
  }
}

# Route Table Public
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = "${aws_vpc.Apache_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Apache_Internet_gateway.id}"
  }

  tags {
    Name = "Public Route"
  }
}

# Route Table Private
resource "aws_default_route_table" "Private_Route_Table" {
  default_route_table_id = "${aws_vpc.Apache_vpc.default_route_table_id}"

  tags {
    Name = "Private Route"
  }
}

# NAT for Private Subnet
resource "aws_nat_gateway" "Private_NAT" {
  //other arguments

  depends_on = ["aws_internet_gateway.gw"]
}

# Apache Public Subnet 1A
resource "aws_subnet" "Public_Subnet_1A" {
  vpc_id                  = "${aws_vpc.Apache_vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Public_Subnet_1A"
  }
}

# Apache Public Subnet 1C

resource "aws_subnet" "Public_Subnet_1C" {
  vpc_id                  = "${aws_vpc.Apache_vpc.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "Public_Subnet_1C"
  }
}

# Apache Private Subnet 1A 

resource "aws_subnet" "Private_Subnet_1A" {
  vpc_id                  = "${aws_vpc.Apache_vpc.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Private_Subnet_1A"
  }
}

# Apache Private Subnet 1C
resource "aws_subnet" "Private_Subnet_1C" {
  vpc_id                  = "${aws_vpc.Apache_vpc.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "Private_Subnet_1C"
  }
}

# Adding Subnets to Route Table
resource "aws_route_table_association" "bastion_route" {
  subnet_id      = ["${aws_subnet.Public_Subnet_1A.id}", "${aws_subnet.Public_Subnet_1C.id}"]
  route_table_id = "${aws_route_table.Public_Route_Table.id}"
}

resource "aws_route_table_association" "web" {
  subnet_id      = ["${aws_subnet.Private_Subnet_1A.id}", "${aws_subnet.Private_Subnet_1C.id}"]
  route_table_id = "${aws_route_table.Private_Route_Table.id}"
}

# Public Security Groups ß

resource "aws_security_group" "Bastion_SG" {
  name        = "Bastion_SG"
  description = "Access to Bastion Host"
  vpc_id      = "${aws_vpc.Apache_vpc.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SP_cidrs["work_ipaddress"]}", "${var.SP_cidrs["home_ipaddress"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Private_Web" {
  name        = "Dublin_public_SG"
  description = "Used for the ELB for public Access"
  vpc_id      = "${aws_vpc.Apache_vpc.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SP_cidrs["public1"]}", "${var.SP_cidrs["public2"]}"]
  }

  #HTTP 
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
}

# ---------- EC2 Instance ------------------

