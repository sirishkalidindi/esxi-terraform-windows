data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# SOURCE VM (NOT TEMPLATE)
data "vsphere_virtual_machine" "source_vm" {
  name          = var.source_vm_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "windows_vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.cpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.source_vm.guest_id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_vm.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_vm.disks[0].size
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_vm.id

    customize {
      windows_options {
        computer_name  = var.vm_name
        admin_password = var.admin_password
      }
    }
  }
}
