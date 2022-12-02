module "libvirt_vms" {
  source                        = "../modules/libvirt_vms"
  libvirt_vms_project           = var.project
  libvirt_vms_net               = var.libvirt_vms_net
  libvirt_vms_default_user      = var.ansible_user
  libvirt_vms_domain_defaults   = var.libvirt_domain_defaults
  libvirt_vms_domains           = var.libvirt_domains
  libvirt_vms_pool_isos         = var.libvirt_vms_pool_isos
}


locals {
  vms_types = {
    for key, value in var.libvirt_domains : lookup(value, "type", "common") => key...
  }
}

resource "local_file" "hosts" {
  filename        = "${var.ansible_base_path}/inventory/inventory_${var.project}.yml"
  file_permission = "0640"
  content         = <<EOT
all:
  hosts:
    localhost:
      ansible_connection: local
  children:
    ${var.project}:
      vars:
        ansible_user: ${var.ansible_user.name}
        ansible_ssh_private_key_file: ${var.ansible_user.ssh_key}
        ansible_become: yes
        ansible_ssh_extra_args: "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
      children:
      %{~for key, value in local.vms_types~}
        ${key}:
          hosts:
          %{~for server in value~}
            ${module.libvirt_vms.libvirt_domains[server].name}:
              ansible_host: ${module.libvirt_vms.libvirt_domains[server].network_interface.0.addresses.0}
          %{~endfor~}
      %{~endfor~}
EOT
}
resource "null_resource" "ansible" {
  triggers = {
    hosts = sha256(local_file.hosts.content)
  }

  provisioner "local-exec" {
    working_dir = "${var.ansible_base_path}"
    command     = "ansible-playbook -i ${var.ansible_base_path}/inventory/inventory_${var.project}.yml playbook_base.yml"
  }
}