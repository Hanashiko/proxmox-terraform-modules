output "node_01_id" {
  value = module.node_01.vm_id
}

output "node_01_ipv4" {
  description = "IP адреси node-01 (від QEMU guest agent)"
  value = try(
    [for ip in flatten(module.node_01.ipv4_addresses) : ip if !startswith(ip, "127.")],
    []
  )
}

output "node_02_id" {
  value = module.node_02.vm_id
}

output "node_02_ipv4" {
  description = "IP адреси node-02 (від QEMU guest agent)"
  value = try(
    [for ip in flatten(module.node_02.ipv4_addresses) : ip if !startswith(ip, "127.")],
    []
  )
}

output "control_plane_01_id" {
  value = module.control_plane_01.vm_id
}

output "control_plane_01_ipv4" {
  description = "IP адреси control-plane-01 (від QEMU guest agent)"
  value = try(
    [for ip in flatten(module.control_plane_01.ipv4_addresses) : ip if !startswith(ip, "127.")],
    []
  )
}

output "control_plane_02_id" {
  value = module.control_plane_02.vm_id
}

output "control_plane_02_ipv4" {
  description = "IP адреси control-plane-02 (від QEMU guest agent)"
  value = try(
    [for ip in flatten(module.control_plane_02.ipv4_addresses) : ip if !startswith(ip, "127.")],
    []
  )
}