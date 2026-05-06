variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type = string
  sensitive = true
}

variable "vm_password" {
  type = string
  sensitive = true
}