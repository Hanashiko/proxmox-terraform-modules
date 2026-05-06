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

# крок 1 створюєм вм з ісо для ручного інстала
module "ubuntu_install_vm" {
  source = "../../modules/vm-to-template"

  proxmox_node = "pve-2"
  vm_name      = "ubuntu-2404-install"
  vm_id        = 8999

  iso_source = "url"
  iso_url    = "https://releases.ubuntu.com/24.04/ubuntu-24.04.2-live-server-amd64.iso"
  iso_checksum = "sha256:d6dab0c3a657988501b4bd04add70ea3c42500255c1f0a484f5c8e9e7eb8e85b"
  iso_datastore = "local"

  cpu_cores  = 2
  memory_mb  = 2048
  disk_size  = "20G"
  bios       = "ovmf"  # UEFI
  machine_type = "q35"

  started = false  # запустиш вручну після apply
}

# крок 2 після ручного інстала налаштовуємо клауд ініт і агена та конвертуємо в темплейт
module "ubuntu_template" {
  source = "../../modules/vm-to-template"

  proxmox_node     = "pve"
  convert_existing = true
  existing_vm_id   = module.ubuntu_install_vm.vm_id

  proxmox_api_endpoint = var.proxmox_endpoint
  proxmox_api_token = var.proxmox_api_token

  depends_on = [module.ubuntu_install_vm]
}

# клонуємо з темплейта
module "web_01" {
  source = "../../modules/vm-to-template"

  proxmox_node = "pve"
  vm_name      = "web-01"
  template_id  = module.ubuntu_template.template_vm_id

  cpu_cores = 4
  memory_mb = 8192
  disk_size = 40

  ipv4_address = "dhcp"
  ssh_public_keys = [file("~/.ssh/proxmox-office-two.pub")]

  depends_on = [module.ubuntu_template]
}