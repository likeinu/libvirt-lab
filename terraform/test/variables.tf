variable "project" {
  type        = string
  description = "Project or lab name. Used for pool, network name and so on"
}

variable "libvirt_vms_pool_isos" {
  type        = string
  description = "Pool for init iso"
}

variable "ansible_user" {
  type        = map(any)
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


variable "libvirt_domain_defaults" {
  type        = map(any)
  description = "Default domain parameters"
}

variable "libvirt_domains" {
  type        = map(any)
  description = "All domains with their parameters"
}

variable "ansible_base_path" {
  type        = string
  description = "Path to ansible dir for base configuration"
}

variable "default_group" {
  type        = string
  description = "Default group for vms in ansible"
}