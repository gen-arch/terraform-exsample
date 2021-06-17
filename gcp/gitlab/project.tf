variable "project" {
  type = string
}

provider "google" {
  project = var.project
  region  = "asia-northeast1"
}

provider "google-beta" {
  project = var.project
  region  = "asia-northeast1"
}

module "common" {
  source = "../modules/common"
}

module "network" {
  source = "../modules/network/simple"

  name = "example"
  cidr = "172.16.0.0/16"
}

module "nat" {
  source = "../modules/network/nat"

  name    = "example"
  network = module.network.network.self_link
  subnets = [module.network.subnet.self_link]
}

