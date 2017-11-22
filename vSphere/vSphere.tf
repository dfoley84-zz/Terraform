provider "vmware" {
  vcenter_server = "${var.Vsphere}"
  user = "${var.user}"
  password = "${var.passwd}"
}
resource "vmware_virtual_machine" "web" {
  name =  "web-1"
  image = "web-base"
}
