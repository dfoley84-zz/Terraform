provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "web" {
  name =  "web-1"
  vcpu = 4
  memory = 12096
  domain = "${var.domain}"
  cluster = "${var.production_cluster}"
  
  network_interface {
    label = "${var.Production}"
    ipv4_address       = "172.27.0.151"
    ipv4_prefix_length = "24"
    ipv4_gateway       = "${var.cix_gateway}"
 }
 
}
