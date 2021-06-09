variable "project" {
  type = string
}

variable "home_ip" {
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

resource "google_compute_security_policy" "default" {
  name = "default"

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          var.home_ip
        ]
      }
    }
    description = "allow from home"
  }
}

