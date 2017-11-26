provider "vmware" {
  vcenter_server = "${var.Vsphere}"
  user = "${var.user}"
  password = "${var.passwd}"
}
resource "vmware_virtual_machine" "web" {
  name =  "web-1"
  vcpu = 4
  memory = 12096
  
  network_interface {
    label = "${var.Production}"
    }
}
