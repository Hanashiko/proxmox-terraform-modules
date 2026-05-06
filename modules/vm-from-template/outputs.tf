output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "ipv4_addresses" {
  description = "IPv4 адреси з QEMU agent (якщо встановлений)"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}

output "mac_addresses" {
  value = proxmox_virtual_environment_vm.this.mac_addresses
}