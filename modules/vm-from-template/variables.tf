variable "proxmox_node" {
  description = "Назва ноди Proxmox (наприклад pve)"
  type = string
}

variable "vm_name" {
  description = "Ім'я VM"
  type = string
}

variable "vm_id" {
  description = "VMID. Якщо null - Proxmox призначить автоматично"
  type = number
  default = null
}

variable "template_id" {
  description = "VMID темплейта для клонування"
  type = number
}

variable "description" {
  description = "Опис VM"
  type = string
  default = ""
}

variable "tags" {
  description = "Список тегів"
  type = list(string)
  default = []
}

# Ресурси

variable "cpu_cores" {
  type = number
  default = 2
}

variable "cpu_type" {
  description = "Тип CPU (host, x86-64-v2-AES, etc.)"
  type = string
  default = "x86-64-v2-AES"
}

variable "memory_mb" {
  type = number
  default = 2048
}

variable "memory_floating_mb" {
  description = "Мінімум RAM (balloon). 0 = вимкнено"
  type = number
  default = 0
}

# Диск

variable "disk_size" {
  description = "Розмір диска (наприклад, '20G'). Overrides темплейт якщо більший"
  type = string
  default = null
}