output "libvirt_vms_domains" {
  value = libvirt_domain.vms_domain
}

output "pools" {
  value = local.pools
}