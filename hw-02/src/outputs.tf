output "vm_web_external_ip" {
  value      = yandex_compute_instance.platform_web.network_interface.0.nat_ip_address
}

output "vm_db_external_ip" {
  value       = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
}