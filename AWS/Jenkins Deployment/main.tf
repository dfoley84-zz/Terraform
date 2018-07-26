provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# data "template_file" "access_policy_s3" {
# template = "${file(userdata/policy.tpl)}"}

# data "template_file" "access_role" {
# template = "${file(userdata/role.tpl)}"}

# S3 policy 
# resource "aws_iam_role_policy" "access_policy" {
# name = "S3_policy"
# role = "${aws_iam_role_policy.access_policy.id}"

# policy = "${data.template_file.access_policy_s3.rendered}"}

# resource "aws_iam_role" "S3_access" {
# name               = "S3 Access"
# assume_role_policy = "${data.template_file.access_role.rendered}"}

# ---------- AWS VPC ------------------
resource "aws_vpc" "VPC" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "Jenkins Deployment"
  }
}

# Gateway for public subnet
resource "aws_internet_gateway" "Internet_gateway" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags {
    Name = "igw"
  }
}

resource "aws_eip" "publicIP" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "Private_NAT" {
  subnet_id     = "${aws_subnet.Public_Subnet_1A.id}"
  allocation_id = "${aws_eip.publicIP.id}"

  tags {
    Name = "Private NAT"
  }
}

# Route Table Public
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = "${aws_vpc.VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Internet_gateway.id}"
  }

  tags {
    Name = "Public Route"
  }
}

# Route Table Private
resource "aws_default_route_table" "Private_Route_Table" {
  default_route_table_id = "${aws_vpc.VPC.default_route_table_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.Private_NAT.id}"
  }

  tags {
    Name = "Private Route"
  }
}

# ---------- AWS VPC Subnets ------------------
resource "aws_subnet" "Public_Subnet_1A" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Public_Subnet_1A"
  }
}

# Apache Public Subnet 1C

resource "aws_subnet" "Public_Subnet_1C" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "Public_Subnet_1C"
  }
}

# Apache Private Subnet 1A 

resource "aws_subnet" "Private_Subnet_1A" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "Private_Subnet_1A"
  }
}

# Apache Private Subnet 1C
resource "aws_subnet" "Private_Subnet_1C" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "Private_Subnet_1C"
  }
}

# Adding Subnets to Route Table
resource "aws_route_table_association" "bastion_route" {
  subnet_id      = "${aws_subnet.Public_Subnet_1A.id}"
  route_table_id = "${aws_route_table.Public_Route_Table.id}"
}

resource "aws_route_table_association" "Jenkins" {
  subnet_id      = "${aws_subnet.Private_Subnet_1A.id}"
  route_table_id = "${aws_default_route_table.Private_Route_Table.id}"
}

# Bastion Security Group

resource "aws_security_group" "Bastion_Security_Group" {
  name        = "Bastion_SG"
  description = "Access to Bastion Host"
  vpc_id      = "${aws_vpc.VPC.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SP_cidrs["work"]}", "${var.SP_cidrs["home"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Jenkins Security Groups
resource "aws_security_group" "Jenkins_Security_Group" {
  name        = "Jenkins Security Groupe"
  description = "Used for Jenkins EC2 Instnace"
  vpc_id      = "${aws_vpc.VPC.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidrs["public1"]}", "${var.cidrs["public2"]}"]
  }

  # Apache TomCat 
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.SP_cidrs["work"]}", "${var.SP_cidrs["home"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Private  Security Groups 
resource "aws_security_group" "Private_Web" {
  name        = "Dublin_public_SG"
  description = "Used for the ELB for public Access"
  vpc_id      = "${aws_vpc.VPC.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidrs["public1"]}", "${var.cidrs["public2"]}"]
  }

  #Salt Stack Firewall ports
  ingress {
    from_port   = 4505
    to_port     = 4506
    protocol    = "tcp"
    cidr_blocks = ["${var.cidrs["public1"]}", "${var.cidrs["public2"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Endpoint 
#data "template_file" "S3_endpoint_policy" {
#template = "${file(userdata/endpoint.tpl)}"

# vars {
#  Principal = "${element(var.principal)}"
#}}

resource "aws_vpc_endpoint" "S3_Endpoint" {
  vpc_id       = "${aws_vpc.VPC.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = ["${aws_vpc.VPC.main_route_table_id}",
    "${aws_route_table.Public_Route_Table.id}",
  ]
}

# S3 Bucket
resource "random_id" "random" {
  byte_length = 6
}

resource "aws_s3_bucket" "S3Bucket" {
  bucket        = "${var.domain_name}_${random_id.random.dec}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "S3 Ansible Bucket"
  }
}

# EC2 Instance
resource "aws_instance" "Jenkins" {
  ami             = "${var.Jenkin_AMI}"
  instance_type   = "${var.jenkins_instance_class}"
  key_name        = "${var.key_name}"
  subnet_id       = "${aws_subnet.Private_Subnet_1C.id}"
  security_groups = ["${aws_security_group.Jenkins_Security_Group.id}"]

  tags {
    name = "Jenkins Master"
  }

  provisioner "local-exec" {
    command = <<EOD
    cat <<EOF > aws_hosts
    [jenkins]
    ${aws_instance.Jenkins.public_ip}
    [jenkins:vars]
    s3code=${aws_s3_bucket.S3Bucket.bucket_domain_name}
    domain=${var.domain_name}
    EOF
    EOD
  }

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.Jenkins.id} && ansible-playbook -i aws_hosts wordpress.yml"
  }
}

# TO - DO
# Auto Scale
# ELB 
# FT For Jenkins  
# Route 53 GoDaddy Domain 

