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
}
