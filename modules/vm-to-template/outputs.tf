output "template_vm_id" {
  description = "VMID темплейта"
  value = var.convert_existing ? (
    var.existing_vm_id
  ) : (
    proxmox_virtual_environment_vm.template[0].vm_id
  )
}

output "template_name" {
  description = "Ім'я темплейта (тільки для нових)"
  value = var.convert_existing ? null : proxmox_virtual_environment_vm.template[0].name
}