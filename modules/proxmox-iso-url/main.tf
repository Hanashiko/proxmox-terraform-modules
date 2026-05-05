terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.85.1"
    }
  }
  required_version = ">= 1.5.0"
}

resource "proxmox_virtual_environment_download_file" "this" {
  for_each = var.iso_images

  content_type = "iso"
  node_name = var.node_name
  datastore_id = var.datastore_id

  url = each.value.url
  file_name = each.value.file_name

  overwrite = true
  upload_timeout = var.upload_timeout_seconds
}