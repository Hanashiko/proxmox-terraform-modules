terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.85.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true
}

module "iso" {
  source            = "../../modules/proxmox-iso-url"
  node_name = "pve-2"
  datastore_id = "local-btrfs"

  iso_images = {
    ubuntu_2404 = {
      url       = "https://mirror.cs.princeton.edu/pub/mirrors/ubuntu-releases/releases/24.04/ubuntu-24.04.4-live-server-amd64.iso"
      file_name = "ubuntu-24.04.2-live-server-amd64.iso"
    }
    debian_12 = {
      url       = "https://mirror.us.mirhosting.net/debian-cd/12.9.0/amd64/iso-dvd/debian-12.9.0-amd64-DVD-1.iso"
      file_name = "debian-12.9.0-amd64-dvd.iso"
    }
  }
}

output "iso_ids" {
  value = module.iso.iso_ids
}