locals {
  # Create map for pools { pool_name => path_to_pool }
  pools = merge(distinct(flatten([for vm, data in var.libvirt_vms_domains : [for disk, d in data.disks :
    {
      d.pool_name == "" ? var.libvirt_vms_project : d.pool_name = d.pool_root_path == "" ? var.libvirt_vms_pools_root : d.pool_root_path
  }]]))...)
  # list(map) of volumes that will be created
  #   volumes = [
  #   {
  #     "name" = "cen-1-root"
  #      ...
  #     "volume_size" = 21811160064
  #   },
  #   {
  #     "name" = "ubu-1-root"
  #     ...
  #     "volume_size" = 11811160064
  #   },
  # ]
  volumes = flatten([for vm, data in var.libvirt_vms_domains : [for disk, d in data.disks : {
    "name"             = "${vm}-${disk + 1}-${d.name}"
    "pool_name"        = d.pool_name == "" ? var.libvirt_vms_project : d.pool_name
    "volume_base_name" = d.volume_base_name
    "volume_base_pool" = d.volume_base_pool
    "volume_size"      = d.volume_size
  }]])
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Create all pools for project
resource "libvirt_pool" "vms_pool" {
  for_each = local.pools
  name     = each.key
  type     = "dir"
  path     = "${each.value}/${each.key}"
}

# Create init disk for project
resource "libvirt_cloudinit_disk" "vms_init" {
  for_each  = var.libvirt_vms_domains
  name      = "${var.libvirt_vms_project}_${each.key}_init.iso"
  pool      = var.libvirt_vms_pool_isos
  user_data = templatefile("${each.value.cloudinit_template == "" ? "${path.module}/cloudinit.tftpl" : each.value.cloudinit_template}", var.libvirt_vms_default_user)
}

# Create all volumes
resource "libvirt_volume" "vms_volume" {
  for_each         = { for volume, data in local.volumes : data.name => data }
  name             = "${each.key}.qcow2"
  pool             = libvirt_pool.vms_pool[each.value.pool_name].name
  base_volume_name = each.value.volume_base_name
  base_volume_pool = each.value.volume_base_pool
  size             = each.value.volume_size
}

# Create network
resource "libvirt_network" "vms_net" {
  name      = var.libvirt_vms_net.name == "" ? var.libvirt_vms_project : var.libvirt_vms_net.name
  mode      = var.libvirt_vms_net.type
  domain    = "${var.libvirt_vms_project}${var.libvirt_vms_net.domain}"
  addresses = var.libvirt_vms_net.net
  autostart = var.libvirt_vms_net.autostart
  dns {
    enabled    = true
    local_only = true
  }
}

# Create VMs
resource "libvirt_domain" "vms_domain" {
  for_each  = var.libvirt_vms_domains
  name      = "${each.key}.${var.libvirt_vms_project}"
  vcpu      = each.value.vcpu
  memory    = each.value.memory
  autostart = each.value.autostart
  cloudinit = libvirt_cloudinit_disk.vms_init[each.key].id
  dynamic "console" {
    for_each = each.value.console[*]
    content {
      type        = console.value.type
      target_port = console.value.target_port
      target_type = console.value.target_type
      source_path = console.value.source_path
    }
  }
  dynamic "cpu" {
    for_each = each.value.cpu[*]
    content {
      mode = cpu.value.type
    }

  }

  network_interface {
    network_id     = libvirt_network.vms_net.id
    hostname       = each.key
    wait_for_lease = true
    addresses      = each.value.addresses
    mac            = each.value.mac
  }
  graphics {
    type           = each.value.graphics_type
    autoport       = each.value.graphics_autoport
    listen_type    = each.value.graphics_listen_type
    listen_address = each.value.graphics_listen_address
    websocket      = each.value.graphics_websocket
  }
  video {
    type = each.value.video_type
  }
  dynamic "disk" {
    for_each = each.value.disks
    content {
      volume_id = libvirt_volume.vms_volume["${each.key}-${disk.key + 1}-${disk.value.name}"].id
    }
  }
  # Check ssh availability
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
