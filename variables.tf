variable "vsphere_user" {}
variable "vsphere_password" {
  sensitive = true
}
variable "vsphere_server" {}

variable "datacenter" {
  default = "ha-datacenter"
}

variable "datastore" {
  default = "datastore1"
}

variable "network" {
  default = "VM Network"
}

variable "resource_pool" {
  default = "Resources"
}

variable "source_vm_name" {
  default = "windows-base-vm"
}

variable "vm_name" {
  default = "terraform-windows-vm"
}

variable "cpu" {
  default = 2
}

variable "memory" {
  default = 4096
}

variable "admin_password" {
  sensitive = true
}
