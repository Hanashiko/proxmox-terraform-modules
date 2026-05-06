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

#cloud image
variable "image_url" {
  description = "URL cloud образу (.qcow2 або .img)"
  type = string
}

variable "image_checksum" {
  description = "Checksum у форматі 'algorithm:hash'. Якщо null - перевірка вимкнена"
  type = string
  default = null
}

variable "image_datastore" {
  description = "Datastore куди Proxmox завантажить образ (має підтримувати 'snippets' або 'import')"
  type = string
  default = "local-btrfs"
}

#disk
variable "disk_datastore" {
  description = "Datastore для фінального диска VM (може відрізнятись від image_datastore)"
  type = string
  default = "local-btrfs"
}

variable "disk_size" {
  description = "Розмір диска. Має бути >= розміру образу. Якщо більший - диск розшириться"
  type = number
  default = 20
}

variable "disk_interface" {
  type = string
  default = "scsi0"
}

variable "disk_ssd" {
  type = bool
  default = true
}

variable "disk_cache" {
  description = "none (рекомендовано для prod), writeback (швидше для dev)"
  type = string
  default = "none"
}

#cloud init
variable "cloud_init_datastore" {
  description = "Datastore для cloud-init drive (окремий маленький диск)"
  type = string
  default = "local-btrfs"
}

variable "ipv4_address" {
  description = "CIDR або 'dhcp'"
  type = string
  default = "dhcp"
}

variable "ipv4_gateway" {
  type = string
  default = null
}

variable "dns_servers" {
  type = list(string)
  default = ["1.1.1.1","8.8.8.8"]
}

variable "cloud_init_user" {
  type = string
  default = "ubuntu"
}

variable "cloud_init_password" {
  type = string
  sensitive = true
  default = null
}

variable "ssh_public_keys" {
  type = list(string)
  default = []
}

#extra cloud init user data
variable "user_data_file_id" {
  description = "file_id сніпету з user-data на Proxmox (proxmox_virtual_environment_file)"
  type = string
  default = null
}

# cpu / ram
variable "cpu_cores" {
  type = number
  default = 2
}

variable "cpu_type" {
  type = string
  default = "x86-64-v2-AES"
}

variable "memory_mb" {
  type = number
  default = 2048
}

#network
variable "network_bridge" {
  type = string
  default = "vmbr0"
}

variable "network_vlan_id" {
  type = number
  default = null
}

variable "bios" {
  type = string
  default = "seabios"
}

variable "machine_type" {
  type = string
  default = "pc"
}

variable "efi_datastore" {
  type = string
  default = "local-btrfs"
}

variable "scsi_controller" {
  type = string
  default = "virtio-scsi-pci"
}

# behavior
variable "make_template" {
  description = "Зробити VM темплейтом після створення (для pipeline: image -> template -> clone)"
  type = bool
  default = false
}

variable "started" {
  type = bool
  default = true
}

variable "on_boot" {
  type = bool
  default = false
}