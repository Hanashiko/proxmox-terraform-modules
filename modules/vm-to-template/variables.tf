variable "proxmox_node" {
  type = string
}

variable "convert_existing" {
  description = <<-EOT
true  — конвертувати вже існуючу VM (за vm_id) в темплейт через API call
false — створити нову VM і одразу позначити як темплейт (template = true)
  EOT
  type    = bool
  default = false
}

#для convert_existing = true
variable "existing_vm_id" {
  description = "VMID існуючої VM для конвертації в темплейт"
  type        = number
  default     = null
}

variable "proxmox_api_endpoint" {
  description = "Proxmox API endpoint (наприклад https://proxmox.example.com:8006)"
  type        = string
  default     = null
}

variable "proxmox_api_token" {
  description = "API token у форматі 'user@realm!tokenid=secret'"
  type        = string
  sensitive   = true
  default     = null
}

#для convert_existing = false (нова VM-темплейт)
variable "vm_id" {
  description = "VMID нового темплейта"
  type        = number
  default     = null
}

variable "vm_name" {
  description = "Ім'я темплейта"
  type        = string
  default     = "base-template"
}

variable "description" {
  type    = string
  default = ""
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "cpu_type" {
  type    = string
  default = "x86-64-v2-AES"
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "disk_datastore" {
  type    = string
  default = "local-lvm"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "machine_type" {
  type    = string
  default = "q35"
}

variable "cloud_init_datastore" {
  description = "Datastore для cloud-init диска (якщо потрібен у темплейті)"
  type        = string
  default     = null
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}