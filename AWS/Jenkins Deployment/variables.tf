variable "aws_region" {}
variable "aws_profile" {}

data "aws_availability_zones" "available" {}

variable "vpc_cidr_block" {}

variable "SP_cidrs" {
  type = "map"
}

variable "cidrs" {
  type = "map"
}
