aws_region = "eu-west-1"

aws_profile = "Terraform"

vpc_cidr_block = "172.217.0.0/16"

cidrs = {
  public1  = "172.217.1.0/24"
  public2  = "172.217.2.0/24"
  private1 = "172.217.3.0/24"
  private2 = "127.217.4.0/24"
}

SP_cidrs = {
  home = "109.255.202.101/32"
  work = "109.255.202.102/32"
}
