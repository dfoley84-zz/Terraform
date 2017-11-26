provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

resource "vsphere_folder" "WebFolder" {
  datacenter = "${var.vphere_datacenter}"
  type = "vm"
  path = "${var.path}"
}
resource "vsphere_virtual_machine" "web" {
  name =  "web-1"
  folder = "${vsphere_folder.webFolder.path}"
  vcpu = 4
  memory = 12096
  datacenter = "${var.vphere_datacenter}"
  domain = "${var.domain}"
  cluster = "${var.production_cluster}"

  network_interface {
    label = "${var.Production}"
    ipv4_address       = ""
    ipv4_prefix_length = "24"
    ipv4_gateway       = "${var.cix_gateway}"
 }
 disk {
  template = "${var.Web_Template}"
 }
}
