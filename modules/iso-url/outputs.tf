output "iso_ids" {
  description = <<-EOT
Map key -> Proxmox file id.
Формат: "local:iso/<file_name>"
Передавай напряму в proxmox_virtual_environment_vm -> cdrom -> file-id.
  EOT
  value = {
    for k, v in proxmox_virtual_environment_download_file.this : k => v.id
  }
}