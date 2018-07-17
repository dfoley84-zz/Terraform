#Creating Server from Clone Instance 

provider "vsphere"
 {
  user           = "${var.Username}"
  password       = "${var.Password}"
  vsphere_server = "${var.Server}"
  allow_unverified_ssl = true
}
resource "vsphere_folder" "Terraform_Folder" {
    datacenter = "${var.vphere_datacenter}"
    path = "${var.vRealizeFolder}"
}

resource "vsphere_virtual_machine" "Production Server" {
    name =  "${var.prdouction_prefix} + Test123"
    folder = "${vsphere_folder.Terraform_Folder.path}"
    cluster = "${var.production_cluster}"
    vcpu = 4
    memory = 12096  
  
network_interface{
    label = "${var.vlan105}"
    ipv4_address       = "10.40.105.225"
    ipv4_prefix_length = "24"
    ipv4_gateway       = "10.40.105.100"
}
disk {
  datastore = "${var.storage}"
  template = "${var.Windows}"
}
}
