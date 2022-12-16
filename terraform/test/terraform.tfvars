project                = "test"
libvirt_vms_pool_isos  = "isos"
ansible_base_path      = "../../ansible/base"
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

# Add type(group) for vms (it isn't needed for module libvirt_vms, but it is needed for ansible)
libvirt_vms_domains = {
  ro9 = {
    type                 = "app"
    graphics_type        = "vnc"
    graphics_listen_type = "address"
    console = {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
    }

    cpu = {
      type = "host-passthrough"
    }
    disks = [
      {
        volume_base_name = "rocky-9.qcow2"
        volume_base_pool = "bases"
        name             = "root"
      }
    ]
  }
  # fed37 = {
  #   type                 = "app"
  #   graphics_type        = "vnc"
  #   graphics_listen_type = "address"
  #   cpu = {
  #     type = "host-passthrough"
  #   }
  #   disks = [
  #     {
  #       volume_base_name = "fedora-37.qcow2"
  #       volume_base_pool = "bases"
  #       name             = "root"
  #     }
  #   ]
  # }
}