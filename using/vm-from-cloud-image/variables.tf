variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type = string
  sensitive = true
}

variable "proxmox_ssh_user" {
  description = "SSH юзер для Proxmox хоста (потрібен для завантаження snippet файлів)"
  type        = string
  default     = "root"
}

variable "proxmox_ssh_key_path" {
  description = "Шлях до приватного SSH ключа для Proxmox хоста"
  type        = string
  default     = "~/.ssh/proxmox-office-two"
}

variable "vm_password" {
  description = "Пароль для входу через VNC / консоль (cloud-init)"
  type        = string
  sensitive   = true
}