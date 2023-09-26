locals {
  vm_web_name = "netology-${ var.env }-${ var.project }-${ var.role_1}"
  vm_db_name  = "netology-${ var.env }-${ var.project }-${ var.role_2}" 
}

locals {
  vms_metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}