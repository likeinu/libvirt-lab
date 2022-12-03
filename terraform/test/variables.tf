# Variables for(from) module libvirt_vms 
variable "project" {
  type        = string
  description = "Project or lab name. Used for pool, network name and so on"
}

variable "libvirt_vms_pool_isos" {
  type        = string
  description = "Pool for init iso"
}

variable "libvirt_vms_pools_root" {
  type        = string
  description = "Root path to pool."
}

variable "ansible_user" {
  type        = map(any)
  description = "User for ansible with name, ssh_key and other information."
}

variable "libvirt_vms_net" {
  type = any
}

variable "libvirt_vms_domains" {
  type        = any
  description = "All domains with their parameters"
}

variable "ansible_base_path" {
  type        = string
  description = "Path to ansible dir for base configuration"
}

variable "default_vm_type" {
  type        = string
  description = "Default group for vms in ansible"
}