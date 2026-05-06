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

module "web_01" {
  source = "../../modules/vm-from-cloud-image"

  proxmox_node = "pve-2"
  vm_name = "web-01"

  image_url      = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  image_checksum = null

  cpu_cores = 2
  memory_mb = 2048
  disk_size = 10

  ipv4_address = "dhcp"
  ssh_public_keys = [file("/home/hani/.ssh/proxmox-office-two.pub")]

  make_template = false
  started = true
}