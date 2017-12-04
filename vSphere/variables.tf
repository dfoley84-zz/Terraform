# Office vSphere
variable "Officevsphere_user"{}
variable "Officevsphere_server"{}
variable "Officevsphere_password"{}
variable "Officevphere_datacenter"{}
variable "Officeproduction_cluster"{}
variable "Office_gateway"{}
variable "cix_gateway"{}
variable "office_domain"{}


# DC vSphere
variable "DCvsphere_user"{}
variable "DCvsphere_server"{}
variable "DCvsphere_password"{}
variable "DC_domain"{}
variable "CIX_vphere_datacenter"{}
variable "CIX_production_cluster"{}
variable "DUB_vspere_datacenter"{}
variable "DUB_production_cluster"{}
variable "DC_domain"{}


# Network VDs
variable "office_Production"{}
variable "Office_vCenter"{}
variable "OfficeNSX_Production"{}
variable "CIX_DB"{}
variable "CIX_DMZ"{}
variable "CIX_FaultTolerance"{}
variable "CIX_Management"{}
variable "CIX_Production"{}
variable "CIX_vMotion"{}
variable "CIX_vSphere"{}
variable "CIX_Web"{}
variable "DUB_FaultTolerance"{}
variable "DUB_DB"{}
variable "DUB_DMZ"{}
varibale "DUB_Management"{}
variable "DUB_Production"{}
variable "DUB_VMNetwork"{}
variable "DUB_Web"{}

#Storage
variable "Office_RAID5_4TB"{}
variable "Office_RAID5_1TB"{}
variable "Office_ESXi1DataStore"{}
variable "CIX_2TB_SSD"{}
variable "CIX 7TB_FC"{}
variable "CIX_ESXi1DataStore"{}
variable "CIX_ESXi2DataStore"{}
variable "DUB_2TB_SSD"{}
variable "DUB_7TB_FC"{}
variable "DUB_datastore1"{}
variable "DUB_datastore2"{}

#VM Clones
variable "CIX_Cent"{}
variable "CIX_Win2012"{}
variable "CIX_Win2016"{}
variable "DUB_Cent"{}
variable "DUB_Win2012"{}
variable "DUB_Win2016"{}
variable "Office_Cent"{}
variable "Office_win2012"{}
variable "office_Win2016"{}
variable "CIX_WebServer"{}
