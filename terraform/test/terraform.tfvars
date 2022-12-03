project               = "test"
libvirt_vms_pool_isos = "isos"
ansible_base_path     = "../../ansible/base"
libvirt_vms_pools_root = "/wrk/kvm/pools"

ansible_user = {
  name    = "ansible"
  ssh_key = "~/.ssh/id_ans_local"
}

libvirt_vms_net = {
  name   = ""
  net    = ["192.168.111.0/24"]
  type   = "nat"
  domain = ".llab"
}

default_vm_type = "common"

# Add type(group) for vms (it isn't need for module libvirt_vms, but it's need for ansible)
libvirt_vms_domains = {
  ubu20 = {
    type = "app"
    disks = [
      {
        volume_base_name = "ubuntu-focal.qcow2"
        volume_base_pool = "bases"
        name             = "root"
      }
    ]
  }
  cen8 = {
    type = "app"
    disks = [
      {
        volume_base_name = "centos-8-stream.qcow2"
        volume_base_pool = "bases"
        name             = "root"
      }
    ]
  }
}