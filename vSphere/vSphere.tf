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
  
  network_interface {
    label = "${var.Production}"
    }
}
