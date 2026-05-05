output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "iso_file_id" {
  value = local.iso_file_id
  description = "Фінальний file_id ISO (корисно для debug)"
}