variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type = string
  sensitive = true
}

variable "vm_password" {
  description = "Пароль для входу через VNC / консоль (cloud-init)"
  type        = string
  sensitive   = true
}