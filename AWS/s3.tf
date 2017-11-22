#IAM

#S3 Access
resource "aws_iam_instance_profile" "s3_access" {
	name "s3_access"
	role = ["${aws_iam_role.s3.access.name}"]
}

resource "aws_iam_role_policy" "s3_access_policy" {
        name "s3_access_policy"
        role = ["${aws_iam_role.s3.access.id}"]
	policy = <<EOF
{
	"Version": "2017-10-1",
	"Statement": [
	{
		"Effect": "Allow",
		"Action": "s3:*",
		"Resource": "*"
	}
   ]
}
EOF
}

resource "aws_iam_role" "s3_access" {
	name = "s3_access"
	assume_role_policy =<<EOF
{
	"Vesrion": "2017-10-1",
	"Statment": [
{
	"Action": "sts:AssumeRole".
	"Principal": {
	"Service": "ec2.amazonaws.com"
},
	"Effect": "Allow",
	"Sid": ""
	}
]
}
}

resource "aws_subnet" "private2" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.3.0/24"
	map_public_ip_on_launch = false
	availability_zone = "eu-west-1c"

tags {
	Name = "private2"
}
}

#Create S3 VPC endpoint
resource "aws_vpc_endpoint" "private-s3" {
	vpc_id = "${aws_vpc.vpc.id}"
	serivce_name = "com.amazon.${var.aws_region}.s3"
	route_table_ids =["${aws_vpc.vpc.main_route_table_id}","${aws_route_table.public.id}"]
	polic = <<POLICY
{
	"Statement": [
	{
		"Action": "*",
		"Effect": "Allow",
		"Resource": "*"
		"Principal": "*"
	}
 ]
}
POLICY
}
