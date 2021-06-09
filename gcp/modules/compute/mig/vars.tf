variable "hc" {
  type = map(any)
  default = {
    check_interval_sec  = 5
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
    path                = "/"
    port                = 80
  }
}
variable "machine_type" {
  default = "n1-standard-1"
}
variable "image" {
  default = "ubuntu-2004-focal-v20210315"
}

variable "name" {}
variable "subnet" {}
variable "region" {}
variable "zone" {}
variable "size" {}
variable "startup_script" {
  default = ""
}
variable "cloud_init" {
  default = ""
}


