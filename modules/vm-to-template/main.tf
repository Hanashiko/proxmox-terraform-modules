#варіант A: Нова VM одразу як темплейт
resource "proxmox_virtual_environment_vm" "template" {
  count = var.convert_existing ? 0 : 1

  node_name   = var.proxmox_node
  name        = var.vm_name
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags

  # Ключовий прапорець — VM стає темплейтом
  template = true

  # VM-темплейт не запускається
  started = false
  on_boot = false

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
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.disk_datastore
    size         = var.disk_size
    file_format  = "raw"
    ssd          = true
    discard      = "on"
  }

  # Cloud-Init диск — потрібен якщо плануєш клонувати з cloud-init
  dynamic "initialization" {
    for_each = var.cloud_init_datastore != null ? [1] : []
    content {
      datastore_id = var.cloud_init_datastore
      # Без user_account/ip_config — заповниться при клонуванні
    }
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  lifecycle {
    # Темплейт не повинен оновлюватись після створення
    ignore_changes = all
  }
}

#варіант B: Конвертація існуючої VM через Proxmox API

# Використовуємо terraform_data + local-exec з curl до Proxmox API.
# Proxmox REST API endpoint: POST /nodes/{node}/qemu/{vmid}/template
resource "terraform_data" "convert_to_template" {
  count = var.convert_existing ? 1 : 0

  # Тригер: перезапустити якщо змінився vm_id
  input = var.existing_vm_id

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-BASH
      set -euo pipefail

      VMID="${var.existing_vm_id}"
      NODE="${var.proxmox_node}"
      ENDPOINT="${var.proxmox_api_endpoint}"
      TOKEN="${var.proxmox_api_token}"

      echo "Зупиняємо VM $VMID перед конвертацією..."
      STATUS=$(curl -sf \
        -H "Authorization: PVEAPIToken=$TOKEN" \
        "$ENDPOINT/api2/json/nodes/$NODE/qemu/$VMID/status/current" \
        | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['status'])")

      if [ "$STATUS" = "running" ]; then
        curl -sf -X POST \
          -H "Authorization: PVEAPIToken=$TOKEN" \
          "$ENDPOINT/api2/json/nodes/$NODE/qemu/$VMID/status/stop"

        echo "Чекаємо зупинки VM..."
        for i in $(seq 1 30); do
          sleep 2
          STATUS=$(curl -sf \
            -H "Authorization: PVEAPIToken=$TOKEN" \
            "$ENDPOINT/api2/json/nodes/$NODE/qemu/$VMID/status/current" \
            | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['status'])")
          [ "$STATUS" = "stopped" ] && break
          echo "  Спроба $i/30: статус = $STATUS"
        done
      fi

      echo "Конвертуємо VM $VMID в темплейт..."
      RESULT=$(curl -sf -X POST \
        -H "Authorization: PVEAPIToken=$TOKEN" \
        "$ENDPOINT/api2/json/nodes/$NODE/qemu/$VMID/template")

      echo "Результат: $RESULT"
      echo "VM $VMID успішно конвертована в темплейт."
    BASH
  }
}