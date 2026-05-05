variable "node_name" {
  description = "Proxmox нода (наприклад: 'pve')"
  type = string
}

variable "iso_images" {
  description = "Map ISO образів. Key - логічне ім'я, values - url і file_name"
  type = map(object({
    url = string
    file_name = string
  }))
}

variable "upload_timeout_seconds" {
  description = "Скільки секунд чекати завершення завантаження (default 30 хв)"
  type = number
  default = 1800
}

variable "datastore_id" {
  description = "Proxmox storage id"
  type = string
  default = "local"
}