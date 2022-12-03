provider "libvirt" {
  uri = "qemu:///system"
}

# Pool for base images (https://libvirt.org/kbase/backing_chains.html)
resource "libvirt_pool" "base" {
  name = var.pool_base
  type = "dir"
  path = "${var.pools_path_root}/${var.pool_base}"
}

# Create my base volumes for my VMs
resource "libvirt_volume" "bases" {
  for_each = var.bases
  name     = each.value.name
  source   = each.value.url
  pool     = libvirt_pool.base.name
}

