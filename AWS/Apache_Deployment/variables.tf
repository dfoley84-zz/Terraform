variable "aws_profile" {}
variable "aws_region_Public" {}
variable "aws_region_Private" {}
variable "Apache" {}
variable "Bastion" {}
variable "instance_class" {}
variable "key_name" {}
variable "domain_name" {}
variable "public_key_path" {}
data "aws_availability_zones" "available" {}

variable "cidrs" {
  type = "map"
}

variable "SP_cidrs" {
  type = "map"
}
