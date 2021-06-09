terraform {
  backend "gcs" {
    bucket = "ito-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
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

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}


module "bastion" {
  source = "../modules/compute/instance"

  name       = "bastion"
  subnet     = module.network.subnet.self_link
  nat_ip     = "35.194.102.12"
  image      = data.google_compute_image.ubuntu.self_link
  ip         = "172.16.0.10"
  cloud_init = file("../cloud-inits/step-server.yml")
}


