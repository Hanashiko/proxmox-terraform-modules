output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "cloud_image_id" {
  description = "file_id завантаженого образу на Proxmox"
  value       = proxmox_virtual_environment_download_file.cloud_image.id
}

output "ipv4_addresses" {
  description = "IP адреси від QEMU agent (після старту VM)"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}

output "is_template" {
  value = var.make_template
}