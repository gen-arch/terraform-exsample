variable "machine_type" {
  default = "e2-small"
}
variable "image" {
  default = "ubuntu-pro-2004-focal-v20210423"
}

variable "name" {}
variable "subnet" {}
variable "ip" {
  type = string
  default = ""
}
variable "nat_ip" {
  type = string
  default = ""
}
variable "region" {
  type = string
  default = "asia-northeast1"
}
variable "zone" {
  type = string
  default = "asia-northeast1-a"
}
variable "disk_size" {
  type = string
  default = 10
}
variable "startup_script" {
  type = string
  default = ""
}
variable "cloud_init" {
  type = string
  default = ""
}

variable "labels" {
  type    = map(any)
  default = {}
}

