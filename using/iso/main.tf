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
  source            = "../../modules/iso-url"
  node_name = "pve-2"
  datastore_id = "local-btrfs"

  iso_images = {
    ubuntu_2404 = {
      url       = "https://cloud-images.ubuntu.com/minimal/releases/noble/release-20260415/ubuntu-24.04-minimal-cloudimg-amd64.img"
      file_name = "ubuntu-24.04-minimal-cloudimg.img"
    }
  }
}

output "iso_ids" {
  value = module.iso.iso_ids
}