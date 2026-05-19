resource "proxmox_virtual_environment_download_file" "cloud_image" {
  count = var.image_url != null ? 1 : 0

  node_name    = var.proxmox_node
  content_type = "import"
  datastore_id = var.image_datastore

  file_name = "noble-server-cloudimg-amd64.qcow2"

  url = var.image_url

  checksum           = var.image_checksum != null ? split(":", var.image_checksum)[1] : null
  checksum_algorithm = var.image_checksum != null ? split(":", var.image_checksum)[0] : null

  overwrite           = false
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name   = var.proxmox_node
  name        = var.vm_name
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags
  pool_id     = var.pool_id

#якшо make_template=true то вм одразу стає темлпейтом. тоді started має бути false
  template = var.make_template
  started  = var.make_template ? false : var.started
  on_boot  = var.on_boot

  machine       = var.machine_type
  bios          = var.bios
  scsi_hardware = var.scsi_controller

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
    trim    = true
  }

  disk {
    interface    = var.disk_interface
    datastore_id = var.disk_datastore
    size         = var.disk_size
    file_format  = "raw"

    ssd     = var.disk_ssd
    discard = var.disk_ssd ? "on" : "ignore"
    cache   = var.disk_cache
    iothread = var.scsi_controller == "virtio-scsi-single"

    #імпорт образу як джерело диска
    import_from = var.image_url != null ? proxmox_virtual_environment_download_file.cloud_image[0].id : var.image_id
  }

  dynamic "efi_disk" {
    for_each = var.bios == "ovmf" ? [1] : []
    content {
      datastore_id      = var.efi_datastore
      file_format       = "raw"
      type              = "4m"
      pre_enrolled_keys = true
    }
  }

  initialization {
    datastore_id = var.cloud_init_datastore

    vendor_data_file_id = var.vendor_data_file_id

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_address != "dhcp" ? var.ipv4_gateway : null
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      username = var.cloud_init_user
      password = var.cloud_init_password
      keys     = var.ssh_public_keys
    }
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.network_vlan_id
    model   = "virtio"
  }

  boot_order = [var.disk_interface]

  lifecycle {
    ignore_changes = [
      disk,
    ]
  }
}