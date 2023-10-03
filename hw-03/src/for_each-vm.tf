resource "yandex_compute_instance" "web" {
  for_each             = {for i in var.prod : i.vm_name => i}
  name                 = "${each.value.vm_name}"
  resources {
    cores              = "${each.value.cpu}"
    memory             = "${each.value.ram}" 
  }

  boot_disk {
    initialize_params {
      image_id         = data.yandex_compute_image.ubuntu.image_id
      size             = "${each.value.disk}"
    }
  }

  platform_id          = "standard-v1"

  depends_on           = [ yandex_compute_instance.ubuntu ]

  scheduling_policy {
    preemptible        = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [ yandex_vpc_security_group.example.id ]
  }

  metadata             = local.vms_metadata
}