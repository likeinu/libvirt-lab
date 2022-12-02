variable "libvirt_vms_project" {
  type        = string
  description = "Project or lab name. Used for pool, network name and so on"
}

variable "libvirt_vms_pool_isos" {
  type        = string
  description = "Pool for init iso"
}

variable "libvirt_vms_default_user" {
  type        = map(string)
  description = "User for ansible with name, ssh_key and other information."
}

variable "libvirt_vms_net" {
  type = object({
    name   = string
    net    = list(string)
    type   = string
    domain = string
  })
  description = "Network parameters."
}


variable "libvirt_vms_domain_defaults" {
  type        = map(string)
  description = "Default domain parameters"
}

variable "libvirt_vms_domains" {
  type        = map(any)
  description = "All domains with their parameters"
}
