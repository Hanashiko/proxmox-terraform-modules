resource "proxmox_virtual_environment_download_file" "iso" {
  count = var.iso_source == "url" ? 1 : 0

  node_name = var.proxmox_node
  content_type = "iso"
  datastore_id = var.iso_datastore

  url = var.iso_url
  checksum = var.iso_checksum != null ? split(":", var.iso_checksum)[1] : null
  checksum_algorithm = var.iso_checksum != null ? split(":", var.iso_checksum)[0] : null

  overwrite = false#не перезаписувати якщо вже є
}

locals {
  iso_file_id = var.iso_source == "url" ? (
          proxmox_virtual_environment_download_file.iso[0].id
  ) : (
          "${var.iso_datastore}:iso/${var.iso_file_name}"
  )
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.proxmox_node
  name = var.vm_name
  vm_id = var.vm_id
  description = var.description
  tags = var.tags
  pool_id = var.pool_id

  on_boot = var.on_boot
  started = var.started

  machine = var.machine_type
  bios = var.bios

  operating_system {
    type = var.os_type
  }

  scsi_hardware = var.scsi_controller

  cpu {
    cores = var.cpu_cores
    sockets = var.cpu_sockets
    type = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = var.agent_enabled
    trim = true
  }

  cdrom {
    file_id = local.iso_file_id
    interface = "ide2"
  }

  disk {
    interface = var.disk_interface
    datastore_id = var.disk_datastore
    size = var.disk_size
    file_format = "raw"
    ssd = var.data_ssd
    discard = var.data_ssd ? "on" : "ignore"
    cache = "writeback"
    iothread = true
  }

  dynamic "efi_disk" {
    for_each = var.bios == "ovmf" ? [1] : []
    content {
      datastore_id = var.efi_datastore
      file_format = "raw"
      type = "4m"
      pre_enrolled_keys = true
    }
  }

  network_device {
    bridge = var.network_bridge
    vlan_id = var.network_vlan_id
    model = var.network_model
  }

  boot_order = var.boot_order

  lifecycle {
    ignore_changes = [
      disk,
      cdrom,
      boot_order,
    ]
  }
}