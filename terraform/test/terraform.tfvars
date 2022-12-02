project                       = "test"
libvirt_vms_pool_isos         = "isos"
ansible_base_path          = "../../ansible/base"

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


libvirt_domain_defaults = {
  vcpu             = "1"
  memory           = "1024"
  size             = "11811160064"
  root_pool_path   = "/wrk/kvm/pools"
  pool_name        = ""
  base_volume_pool = "bases"
}

default_group = "common"

libvirt_domains = {
  "app-ubu20" = {
    base_volume_name = "ubuntu-focal.qcow2"
    type             = "app"
  }
  "web-cen8" = {
    base_volume_name = "centos-8-stream.qcow2"
    type             = "web"
  }
}