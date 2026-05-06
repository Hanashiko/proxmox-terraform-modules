variable "proxmox_node" {
  description = "Назва ноди Proxmox (наприклад, pve)"
  type        = string
}

variable "vm_name" {
  description = "Ім'я VM"
  type        = string
}

variable "vm_id" {
  description = "VMID. Якщо null — Proxmox призначить автоматично"
  type        = number
  default     = null
}

variable "template_id" {
  description = "VMID темплейта для клонування"
  type        = number
}

variable "description" {
  description = "Опис VM"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Список тегів"
  type        = list(string)
  default     = []
}

# Ресурси
variable "cpu_cores" {
  type    = number
  default = 2
}

variable "cpu_type" {
  description = "Тип CPU (host, x86-64-v2-AES, etc.)"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "memory_floating_mb" {
  description = "Мінімум RAM (balloon). 0 = вимкнено"
  type        = number
  default     = 0
}

# Диск
variable "disk_size" {
  description = "Розмір диска (наприклад, 20). Overrides темплейт якщо більший"
  type        = number
  default     = null
}

variable "disk_datastore" {
  description = "Datastorе для диска VM (наприклад, local-lvm, ceph-vm)"
  type        = string
  default     = "local-lvm"
}

variable "disk_interface" {
  description = "Інтерфейс диска: scsi0, virtio0, etc."
  type        = string
  default     = "scsi0"
}

# Мережа
variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_vlan_id" {
  type    = number
  default = null
}

variable "ipv4_address" {
  description = "CIDR (192.168.1.10/24) або 'dhcp'"
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  type    = string
  default = null
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

# Cloud-Init
variable "cloud_init_user" {
  type    = string
  default = null
}

variable "cloud_init_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "ssh_public_keys" {
  description = "Список SSH публічних ключів"
  type        = list(string)
  default     = []
}

variable "cloud_init_datastore" {
  description = "Datastore для cloud-init drive"
  type        = string
  default     = "local-lvm"
}

# Поведінка
variable "started" {
  description = "Стартувати VM після створення"
  type        = bool
  default     = true
}

variable "on_boot" {
  description = "Автостарт при завантаженні ноди"
  type        = bool
  default     = false
}

variable "pool_id" {
  description = "Resource pool ID"
  type        = string
  default     = null
}