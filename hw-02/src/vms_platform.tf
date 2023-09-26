# vm1

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "https://cloud.yandex.ru/marketplace/products/yc/ubuntu-20-04-lts"
}
/*
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
}
*/
variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "https://cloud.yandex.ru/docs/compute/concepts/vm-platforms"
}

# vm2

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "https://cloud.yandex.ru/marketplace/products/yc/ubuntu-20-04-lts"
}
/*
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}
*/
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "https://cloud.yandex.ru/docs/compute/concepts/vm-platforms"
}

variable "vm_web_resources" {
  type = map(string)
  default = { vm_web_cores = "2", vm_web_memory = "1", vm_web_core_fraction = "5" }      
}  

variable "vm_db_resources" {
  type = map(string)
  default = { vm_db_cores = "2", vm_db_memory = "2", vm_db_core_fraction = "20" }              
}