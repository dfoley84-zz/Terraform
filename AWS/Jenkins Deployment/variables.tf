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
<<<<<<< HEAD

variable "domain_name" {}
variable "principal" {}
variable "key_name" {}
variable "Jenkin_AMI" {}
variable "jenkins_instance_class" {}
=======
>>>>>>> 1e39c776703b7d56d1bba22b92d619bff8ae6792
