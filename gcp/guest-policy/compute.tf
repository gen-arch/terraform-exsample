data "google_compute_image" "ubuntu-minimal" {
  family  = "ubuntu-minimal-2004-lts"
  project = "ubuntu-os-cloud"
}

module "develop-001" {
  source = "../modules/compute/instance"

  name       = "develop-001"
  subnet     = module.network.subnet.self_link
  image      = data.google_compute_image.ubuntu-minimal.self_link
  ip         = "172.16.0.11"
  cloud_init = file("../cloud-inits/develop.yml")
  labels = {
    ospolicy-ubuntu-utils = "true"
    ospolicy-ubuntu       = "true"
  }
}

module "develop-002" {
  source = "../modules/compute/instance"

  name       = "develop-002"
  subnet     = module.network.subnet.self_link
  image      = data.google_compute_image.ubuntu-minimal.self_link
  ip         = "172.16.0.12"
  cloud_init = file("../cloud-inits/develop.yml")
  labels = {
    ospolicy-ubuntu-utils = "true"
    ospolicy-ubuntu       = "true"
    ospolicy-container    = "true"
  }
}

module "develop-003" {
  source = "../modules/compute/instance"

  name       = "develop-003"
  subnet     = module.network.subnet.self_link
  image      = data.google_compute_image.ubuntu-minimal.self_link
  ip         = "172.16.0.13"
  cloud_init = file("../cloud-inits/develop.yml")
  labels = {
    ospolicy-ubuntu-utils = "true"
    ospolicy-ubuntu       = "true"
    ospolicy-test         = "true"
  }
}

module "develop-004" {
  source = "../modules/compute/instance"

  name       = "develop-004"
  subnet     = module.network.subnet.self_link
  image      = data.google_compute_image.ubuntu-minimal.self_link
  ip         = "172.16.0.14"
  cloud_init = file("../cloud-inits/develop.yml")
  labels = {
    ospolicy-ubuntu           = "true"
    ospolicy-ubuntu-utils     = "true"
    ospolicy-ubuntu-container = "true"
  }
}
