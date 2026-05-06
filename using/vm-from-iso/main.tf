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

module "ubuntu_install_vm" {
  source = "../../modules/vm-from-iso"

  proxmox_node = "pve-2"
  vm_name = "ubuntu-2404-install"
  vm_id = 8999

  iso_source = "datastore"
  iso_file_name = "ubuntu-24.04-minimal-cloudimg.img"
  iso_datastore = "local-btrfs"

  cpu_cores = 1
  memory_mb = 1024
  disk_size = 10
  bios = "ovmf"
  machine_type = "pc"

  started = false
}