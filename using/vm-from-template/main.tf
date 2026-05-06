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

module "web-server" {
  source = "../../modules/vm-from-template"

  proxmox_node = "pve-2"
  vm_name = "web-02"
  template_id = 9000

  cpu_cores = 4
  memory_mb = 4096

  disk_size = 20
  disk_datastore = "local-btrfs"

  ipv4_address = "192.168.10.50/24"
  ipv4_gateway = "192.168.10.1"
  dns_servers = ["1.1.1.1","8.8.8.8"]

  cloud_init_user = "ubuntu"
  cloud_init_password = var.vm_password
  ssh_public_keys = [file("~/.ssh/proxmox-office-two.pub")]

  tags = ["terraform", "web"]
  on_boot = true
  started = true
}