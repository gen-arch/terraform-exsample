variable "name" {}
variable "region" {
  default = "asia-northeast1"
}
variable "network" {}
variable "subnets" {
  type = list(any)
}
