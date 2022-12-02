locals {
  #
  libvirt_vms_net = merge(var.libvirt_vms_net,
    { name = "${var.libvirt_vms_project}${var.libvirt_vms_net["name"]}" },
    { domain = "${var.libvirt_vms_project}${var.libvirt_vms_net["domain"]}" }
  )
  #
  libvirt_vms_domain_defaults = merge(var.libvirt_vms_domain_defaults,
    { pool_name = "${var.libvirt_vms_project}${var.libvirt_vms_domain_defaults["pool_name"]}" }
  )
 #
  servers = {
    for key, value in var.libvirt_vms_domains : key => merge(local.libvirt_vms_domain_defaults, value)
  }
  #
  pools = {
    for key, value in local.servers : value.pool_name => value.root_pool_path...
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

#
resource "libvirt_pool" "vms_pool" {
  for_each = local.pools
  name     = each.key
  type     = "dir"
  path     = "${each.value[0]}/${each.key}"
}

#
resource "libvirt_cloudinit_disk" "vms_init" {
  name      = "${var.libvirt_vms_project}_init.iso"
  pool      = var.libvirt_vms_pool_isos
  user_data = <<EOF
#cloud-config
users:
  - name: ${var.libvirt_vms_default_user.name}
    lock_passwd: true
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${chomp(file(join(".", [var.libvirt_vms_default_user.ssh_key, "pub"])))}
EOF
}

#
resource "libvirt_network" "vms_net" {
  name      = local.libvirt_vms_net.name
  mode      = local.libvirt_vms_net.type
  domain    = local.libvirt_vms_net.domain
  addresses = local.libvirt_vms_net.net
  autostart = true
  dns {
    enabled    = true
    local_only = true
  }
}

#
resource "libvirt_volume" "vms_volume" {
  for_each         = local.servers
  name             = "${each.key}.qcow2"
  pool             = libvirt_pool.vms_pool[each.value.pool_name].name
  base_volume_name = each.value.base_volume_name
  base_volume_pool = each.value.base_volume_pool
  size             = each.value.size
}

#
resource "libvirt_domain" "vms_domain" {
  for_each  = local.servers
  name      = "${each.key}.${var.libvirt_vms_project}"
  vcpu      = each.value.vcpu
  memory    = each.value.memory
  cloudinit = libvirt_cloudinit_disk.vms_init.id
  disk {
    volume_id = libvirt_volume.vms_volume[each.key].id
  }
  network_interface {
    network_id     = libvirt_network.vms_net.id
    hostname       = each.key
    wait_for_lease = true
  }
  graphics {
    listen_type = "none"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'I am ready!'"
    ]
    connection {
      type        = "ssh"
      user        = var.libvirt_vms_default_user.name
      private_key = file(var.libvirt_vms_default_user.ssh_key)
      host        = self.network_interface.0.addresses.0
      agent       = "false"
    }
  }
}
