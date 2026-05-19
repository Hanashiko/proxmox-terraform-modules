terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.85.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    username    = var.proxmox_ssh_user
    private_key = file(var.proxmox_ssh_key_path)
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_noble" {
  node_name    = "pve-2"
  content_type = "import"
  datastore_id = "local-btrfs"
  file_name    = "noble-server-cloudimg-amd64.qcow2"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

  overwrite           = false
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  node_name    = "pve-2"
  content_type = "snippets"
  datastore_id = "local-btrfs"

  source_raw {
    file_name = "cloud-init-qemu-agent.yaml"
    data      = <<-EOF
      #cloud-config
      runcmd:
        - DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-guest-agent
        - systemctl enable --now qemu-guest-agent
      EOF
  }
}

module "node_01" {
  source = "../../modules/vm-from-cloud-image"

  proxmox_node = "pve-2"
  vm_name      = "node-01"

  image_id = proxmox_virtual_environment_download_file.ubuntu_noble.id

  cpu_cores = 2
  memory_mb = 2048
  disk_size = 10

  ipv4_address        = "dhcp"
  ssh_public_keys     = [file("~/.ssh/proxmox-office-two.pub")]
  cloud_init_password = var.vm_password
  vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

  make_template = false
  started = true
}

module "node_02" {
  source = "../../modules/vm-from-cloud-image"

  proxmox_node = "pve-2"
  vm_name      = "node-02"

  image_id = proxmox_virtual_environment_download_file.ubuntu_noble.id

  cpu_cores = 2
  memory_mb = 2048
  disk_size = 10

  ipv4_address        = "dhcp"
  ssh_public_keys     = [file("~/.ssh/proxmox-office-two.pub")]
  cloud_init_password = var.vm_password
  vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

  make_template = false
  started = true
}

module "control_plane_01" {
  source = "../../modules/vm-from-cloud-image"

  proxmox_node = "pve-2"
  vm_name      = "control-plane-01"

  image_id = proxmox_virtual_environment_download_file.ubuntu_noble.id

  cpu_cores = 2
  memory_mb = 4096
  disk_size = 10

  ipv4_address        = "dhcp"
  ssh_public_keys     = [file("~/.ssh/proxmox-office-two.pub")]
  cloud_init_password = var.vm_password
  vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

  make_template = false
  started = true
}

module "control_plane_02" {
  source = "../../modules/vm-from-cloud-image"

  proxmox_node = "pve-2"
  vm_name      = "control-plane-02"

  image_id = proxmox_virtual_environment_download_file.ubuntu_noble.id

  cpu_cores = 2
  memory_mb = 4096
  disk_size = 10

  ipv4_address        = "dhcp"
  ssh_public_keys     = [file("~/.ssh/proxmox-office-two.pub")]
  cloud_init_password = var.vm_password
  vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

  make_template = false
  started = true
}


# одразу в темплейт для подальшого клонування
# module "ubuntu_2404_template" {
#   source = "../../modules/vm-from-cloud-image"
#
#   proxmox_node = "pve-2"
#   vm_name      = "ubuntu-2404-cloud"
#   vm_id        = 9001
#
#   image_url      = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
#   image_datastore = "local-btrfs"
#   disk_datastore  = "local-btrfs"
#
#   cpu_cores = 2
#   memory_mb = 2048
#   disk_size = 20
#
#   cloud_init_user = "ubuntu"
#   ssh_public_keys = [file("~/.ssh/id_ed25519.pub")]
#
#   # Одразу темплейт — не стартує, cloud-init не виконається
#   # (виконається при першому старті клону)
#   make_template = true
# }

# Клонуємо з cloud-темплейта — cloud-init спрацює при першому старті клону
# module "app_server" {
#   source = "../../modules/vm-from-cloud-image"
#
#   proxmox_node = "pve-2"
#   vm_name      = "app-01"
#   template_id  = module.ubuntu_2404_template.vm_id
#
#   cpu_cores = 4
#   memory_mb = 8192
#   disk_size = 50
#
#   ipv4_address    = "192.168.10.20/24"
#   ipv4_gateway    = "192.168.10.1"
#   ssh_public_keys = [file("~/.ssh/proxmox-office-two.pub")]
#
#   depends_on = [module.ubuntu_2404_template]
# }