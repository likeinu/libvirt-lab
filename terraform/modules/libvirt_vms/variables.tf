# Project name. It's used for VMs name, network name and so on
variable "libvirt_vms_project" {
  type        = string
  description = "Project or lab name. Used for pool, network name and so on"
}

#
variable "libvirt_vms_pools_root" {
  type        = string
  description = "Root path to pool."
}

#
variable "libvirt_vms_pool_isos" {
  type        = string
  description = "Pool for init iso"
}

# User that will be added to VMs by cloud-init
variable "libvirt_vms_default_user" {
  type        = map(string)
  description = "User for VMs with name, ssh_key and other information."
}

#
variable "libvirt_vms_net" {
  type = object({
    name      = string
    net       = list(string)
    type      = string
    domain    = string
    autostart = optional(bool, true)
  })
  description = "Network parameters."
}

#
variable "libvirt_vms_domains" {
  type = map(object({
    vcpu                    = optional(number, 1)
    cloudinit_template      = optional(string, "")
    memory                  = optional(number, 1024)
    autostart               = optional(bool, false)
    addresses               = optional(list(string))
    mac                     = optional(string)
    graphics_type           = optional(string)
    graphics_autoport       = optional(bool)
    graphics_listen_type    = optional(string, "none")
    graphics_listen_address = optional(string)
    graphics_websocket      = optional(string)
    video_type              = optional(string, "cirrus")
    console = optional(object({
      type           = optional(string, "pty")
      target_port    = optional(string, "0")
      target_type    = optional(string, "serial")
      source_path    = optional(string)
      source_service = optional(string)
      source_host    = optional(string)
    }))
    cpu = optional(object({
      type = optional(string)
    }))

    disks = list(object({
      name             = string
      pool_root_path   = optional(string, "")
      pool_name        = optional(string, "")
      volume_base_name = optional(string)
      volume_base_pool = optional(string)
      volume_size      = optional(number, 11811160064)
    }))
  }))
  description = "All domains with their parameters"
}