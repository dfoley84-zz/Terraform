provider "aws" {
  region  = "${var.aws_region_london}"
  profile = "${var.aws_profile_London}"
}

#RHEL For Zabbix 

resource "aws_instance" "" {
  ami             = "${var.AMI_RedHat}"
  instance_type   = "${var.instance_Zabbix}"
  key_name        = "${var.keypair_logrhythm}"
  subnet_id       = "${var.SharedService-private-az1}"
  private_ip = "${var.SharedService-Zabbix_01}"
  security_groups = ["${var.ZabbixSG}"]
    root_block_device {
    volume_size = "100"
  }
  tags {
    name = ""
  }
    user_data = "${file("saltstack.sh")}"
}

resource "aws_instance" "" {
ami = "${var.AMI_RedHat}"
instance_type = "${var.instance_Zabbix}"
key_name = "${var.keypair_logrhythm}"
subnet_id = "${var.SharedService-private-az2}"
security_groups = ["${var.ZabbixSG}"]
 private_ip = "${var.SharedService-Zabbix_02}"
   root_block_device {
    volume_size = "100"
  }
tags {
name = ""
}
    user_data = "${file("saltstack.sh")}"
}


#LR 

resource "aws_instance" "" {
ami = "${var.AMI_Ubuntu_16}"
instance_type = "${var.instance_Zabbix}"
key_name = "${var.keypair_logrhythm}"
security_groups = ["${var.LogRythmSG}"]
subnet_id = "${var.SharedService-private-az1}"
 private_ip = "${var.SharedService-LogRythym_01}"
   root_block_device {
    volume_size = "100"
  }
tags {
name = ""
}
    user_data = "${file("saltstack.sh")}"
}

resource "aws_instance" "" {
ami = "${var.AMI_Ubuntu_16}"
instance_type = "${var.instance_Zabbix}"
key_name = "${var.keypair_logrhythm}"
subnet_id = "${var.SharedService-private-az2}"
security_groups = ["${var.LogRythmSG}"]
 private_ip = "${var.SharedService-LogRythym_02}"
   root_block_device {
    volume_size = "100"
  }
tags {
name = ""
}
    user_data = "${file("saltstack.sh")}"
}

resource "aws_instance" "" {
ami = "${var.AMI_Ubuntu_16}"
instance_type = "${var.instance_Zabbix}"
key_name = "${var.keypair_logrhythm}"
subnet_id = "${var.SharedService-private-az1}"
security_groups = ["${var.LogRythmSG}"]
 private_ip = "${var.SharedService-LogRythym_SysLog_01}"
   root_block_device {
    volume_size = "100"
  }
tags {
name = ""
}
    user_data = "${file("saltstack.sh")}"
}

resource "aws_instance" "" {
ami = "${var.AMI_Ubuntu_16}"
instance_type = "${var.instance_Zabbix}"
key_name = "${var.keypair_logrhythm}"
security_groups = ["${var.LogRythmSG}"]
subnet_id = "${var.SharedService-private-az2}"
 private_ip = "${var.SharedService-LogRythym_SysLog_02}"
   root_block_device {
    volume_size = "100"
  }
tags {
name = ""
}
    user_data = "${file("saltstack.sh")}"
}

