output "libvirt_domains" {
  value = libvirt_domain.vms_domain
}

output "test" {
  value = local.pools
}