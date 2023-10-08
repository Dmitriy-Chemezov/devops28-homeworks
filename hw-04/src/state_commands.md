# module.vpc_dev.yandex_vpc_network.develop:
resource "yandex_vpc_network" "develop" {
    created_at                = "2023-10-08T12:31:43Z"
    default_security_group_id = "enppmht5uigh3cqe19nu"
    folder_id                 = "b1gekisdb0s5l635ec9n"
    id                        = "enpi56n8sscad5ieisv8"
    labels                    = {}
    name                      = "develop"
    subnet_ids                = [
        "e9btvhgomn2mafdpnrdn",
    ]

    timeouts {}
}
# module.vpc_dev.yandex_vpc_subnet.develop:
resource "yandex_vpc_subnet" "develop" {
    created_at     = "2023-10-08T12:31:46Z"
    folder_id      = "b1gekisdb0s5l635ec9n"
    id             = "e9btvhgomn2mafdpnrdn"
    labels         = {}
    name           = "develop"
    network_id     = "enpi56n8sscad5ieisv8"
    v4_cidr_blocks = [
        "10.0.1.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-a"

    timeouts {}
}
# module.test-vm.yandex_compute_instance.vm[0]:
resource "yandex_compute_instance" "vm" {
    allow_stopping_for_update = true
    created_at                = "2023-10-08T12:31:48Z"
    description               = "TODO: description; {{terraform managed}}"
    folder_id                 = "b1gekisdb0s5l635ec9n"
    fqdn                      = "develop-web-0.ru-central1.internal"
    hostname                  = "develop-web-0"
    id                        = "fhmsv2deip8e5ncmmj6g"
    labels                    = {
        "env"     = "develop"
        "project" = "undefined"
    }
    metadata                  = {
        "serial-port-enable" = "1"
        "user-data"          = <<-EOT
            #cloud-config
            users:
              - name: ubuntu
                groups: sudo
                shell: /bin/bash
                sudo: ['ALL=(ALL) NOPASSWD:ALL']
                ssh_authorized_keys:
                  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeEUYlQY8oVizVAzR6j8ziyV6FMERzutiedq3DUmC/M spec1kkgo@mail.ru
            
            package_update: true
            package_upgrade: false
            packages:
             - nginx
        EOT
    }
    name                      = "develop-web-0"
    network_acceleration_type = "standard"
    platform_id               = "standard-v1"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhmd5no8fe7pec2rpf6i"
        disk_id     = "fhmd5no8fe7pec2rpf6i"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd8ecgtorub9r4609man"
            size       = 10
            type       = "network-hdd"
        }
    }

    metadata_options {
        aws_v1_http_endpoint = 1
        aws_v1_http_token    = 2
        gce_http_endpoint    = 1
        gce_http_token       = 1
    }

    network_interface {
        index              = 0
        ip_address         = "10.0.1.5"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:1c:f8:9a:e9"
        nat                = true
        nat_ip_address     = "51.250.13.61"
        nat_ip_version     = "IPV4"
        security_group_ids = []
        subnet_id          = "e9btvhgomn2mafdpnrdn"
    }

    placement_policy {
        host_affinity_rules = []
    }

    resources {
        core_fraction = 5
        cores         = 2
        gpus          = 0
        memory        = 1
    }

    scheduling_policy {
        preemptible = true
    }
}
