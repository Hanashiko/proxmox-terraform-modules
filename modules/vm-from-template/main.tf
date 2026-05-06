resource "proxmox_virtual_environment_vm" "this" {
  node_name   = var.proxmox_node
  name        = var.vm_name
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags
  pool_id     = var.pool_id

  on_boot  = var.on_boot
  started  = var.started

  # Клонування з темплейта
  clone {
    vm_id   = var.template_id
    full    = true # full clone, не linked
    retries = 3 # ретраї при помилці Proxmox API
  }

  # CPU
  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  # RAM
  memory {
    dedicated = var.memory_mb
    floating  = var.memory_floating_mb  # balloon
  }

  # Диск — resize якщо задано
  dynamic "disk" {
    for_each = var.disk_size != null ? [1] : []
    content {
      interface    = var.disk_interface
      datastore_id = var.disk_datastore
      size         = var.disk_size
    }
  }

  # Мережева карта
  network_device {
    bridge  = var.network_bridge
    vlan_id = var.network_vlan_id
    model   = "virtio"
  }

  # Cloud-Init
  initialization {
    datastore_id = var.cloud_init_datastore

    dynamic "ip_config" {
      for_each = [1]
      content {
        ipv4 {
          address = var.ipv4_address
          gateway = var.ipv4_address != "dhcp" ? var.ipv4_gateway : null
        }
      }
    }

    dynamic "dns" {
      for_each = length(var.dns_servers) > 0 ? [1] : []
      content {
        servers = var.dns_servers
      }
    }

    dynamic "user_account" {
      for_each = var.cloud_init_user != null ? [1] : []
      content {
        username = var.cloud_init_user
        password = var.cloud_init_password
        keys     = var.ssh_public_keys
      }
    }
  }

  lifecycle {
    ignore_changes = [
      clone,
      disk,
    ]
  }
}