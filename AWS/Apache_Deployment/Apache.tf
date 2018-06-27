provider "aws" {
  region  = "${var.aws_region_private_1A}"
  profile = "${var.aws_profile}"
}

# ---------- AWS VPC ------------------

# Creating VPC for Apache Deployment 
resource "aws_vpc" "Apache" {
  cidr_block = "172.27.0.0/16"

  tags {
    Name = "Apache Deployment"
  }
}

# Gateway for public subnet
resource "aws_internet_gateway" "Apache_Internet_gateway" {
  vpc_id = "${aws_vpc.Apache.id}"

  tags {
    Name = "Apache_igw"
  }
}

# NAT for Private Subnet
resource "aws_nat_gateway" "Private_NAT" {
  //other arguments

  depends_on = ["aws_internet_gateway.gw"]
}

# Apache Public Subnet 1A
resource "aws_subnet" "Public_Subnet_1A" {
  vpc_id                  = "${aws_vpc.Apache.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Public_Subnet_1A"
  }
}

# Apache Public Subnet 1C

resource "aws_subnet" "Public_Subnet_1C" {
  vpc_id                  = "${aws_vpc.Apache.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "Public_Subnet_1C"
  }
}

# Apache Private Subnet 1A 

resource "aws_subnet" "Private_Subnet_1A" {
  vpc_id                  = "${aws_vpc.Apache.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Private_Subnet_1A"
  }
}

# Apache Private Subnet 1C
resource "aws_subnet" "Private_Subnet_1C" {
  vpc_id                  = "${aws_vpc.Apache.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Private_Subnet_1C"
  }
}

# Route Table Public
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = "${aws_vpc.Apache.id}"

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
  default_route_table_id = "${aws_vpc.Dublin_vpc.default_route_table_id}"

  tags {
    Name = "Private Route"
  }
}

# ---------- EC2 Instance ------------------

