variable "proxmox_node" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_id" {
  type = number
  default = null
}

variable "description" {
  type = string
  default = ""
}

variable "tags" {
  type = list(string)
  default = []
}

variable "pool_id" {
  type = string
  default = null
}

variable "iso_source" {
  description = <<-EOT
Джерело ISO. Два варіанти:
- "datastore" - ISO вже є на proxmox datastore (вказати iso_datastore + iso_file_name)
- "url" - завантажити ISO з URL (вказати iso_url + опційно iso_checksum)
  EOT
  type = string
  validation {
    condition = contains(["datastore", "url"], var.iso_source)
    error_message = "iso_source має бути 'datastore' або 'url'"
  }
}

variable "iso_datastore" {
  description = "Datastore де лежить ISO (для iso_source = 'datastore' або куди завантажити при 'url')"
  type = string
  default = "local"
}

variable "iso_file_name" {
  description = "Ім'я файлу ISO на datastore (наприклад, ubuntu-24.04-live-server-amd64.iso). Для iso_source = 'datastore'"
  type = string
  default = null
}

variable "iso_url" {
  description = "URL для завантаження ISO. Для iso_source = 'url'"
  type = string
  default = null
}

variable "iso_checksum" {
  description = "Checksum ISO у форматі 'algorithm:hash' (наприклад, 'sha256:abc123...'). Для iso_source = 'url'"
  type = string
  default = null
}

# cpu
variable "cpu_cores" {
  type = number
  default = 2
}

variable "cpu_sockets" {
  type = number
  default = 1
}

variable "cpu_type" {
  type = string
  default = "x86-64-v2-AES"
}

# RAM
variable "memory_mb" {
  type = number
  default = 2048
}

# Disk
variable "disk_size" {
  description = "Розмір системного диску (наприклад, '20G')"
  type = string
  default = "10G"
}

variable "disk_datastore" {
  type = string
  default = "local-brtfs"
}

variable "disk_interface" {
  description = "scsi0, virtio0, ide0, sata0"
  type = string
  default = "scsi0"
}

variable "data_ssd" {
  description = "Емулювати SSD (discard + ssd прапорці)"
  type = bool
  default = true
}

# network
variable "network_bridge" {
  type = string
  default = "vmbr0"
}

variable "network_vlan_id" {
  type = number
  default = null
}

variable "network_model" {
  type = string
  default = "virtio"
}

# bios / machine
variable "bios" {
  description = "seabios або ovmf (uefi)"
  type = string
  default = "seabios"
  validation {
    condition = contains(["seabios", "ovmf"], var.bios)
    error_message = "bios має бути 'seabios' або 'ovmf'."
  }
}

variable "machine_type" {
  description = "Тип машини: q35 або i440fx"
  type = string
  default = "i440fx"
}

variable "efi_datastore" {
  description = "Datastore для EFI диска (тільки якщо bios = 'ovmf')"
  type = string
  default = "local-brtfs"
}

# agent and other
variable "agent_enabled" {
  description = "Увімкнути QEMU guest agent"
  type = bool
  default = true
}

variable "on_boot" {
  type = bool
  default = false
}

variable "started" {
  description = "Запустити VM після створення"
  type = bool
  default = false
}

variable "os_type" {
  description = "Тип ОС для Proxmox hints: l26, win11, other, etc"
  type = string
  default = "l26"
}

variable "scsi_controller" {
  description = "Контролер SCSI: virtio-scsi-pci (рекомендовано), lsi, etc"
  type = string
  default = "virtio-scsi-pci"
}

variable "boot_order" {
  description = "Порядок завантаження. ISO буде першим, потім диск"
  type = list(string)
  default = ["ide2","scsi0"]#ide2 - типовий слот для ISO
}