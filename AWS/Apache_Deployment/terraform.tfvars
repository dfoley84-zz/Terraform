aws_profile = "Terraform"

aws_region = "eu-west-1"

instance_class = "t2.mirco"

apache_bucket_name = "apache-s3-bucket"

key_name = "Apache"

public_key_path = "/etc/bastion.pem"

cidrs = {
  public1  = "213.127.10.0/24"
  public2  = "213.127.20.0/24"
  private1 = "231.127.30.0/24"
  private2 = "231.127.40.0/24"
  rds1     = "231.127.50.0/24"
  rds3     = "231.127.60.0/24"
}

SP_cidrs = {
  work_ipaddress = "/32"
  home_ipaddress = "/32"
}
