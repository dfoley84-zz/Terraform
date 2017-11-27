# Create a Virutal Machine from a Clone Instance.

provider "vsphere"
 {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "web" {
  name =  "web-1"
  vcpu = 4
  memory = 12096
  datacenter = "${var.vphere_datacenter}"
  domain = "${var.domain}"
  cluster = "${var.production_cluster}"

  network_interface {
    label = "${var.Production}"
    ipv4_address       = "<< IP ADDRESS>>"
    ipv4_prefix_length = "24"
    ipv4_gateway       = "${var.cix_gateway}"
 }
 disk {
  datastore = "${var.raid5_datastore}"
  template = "${var.webtemplate}"
 }
}
