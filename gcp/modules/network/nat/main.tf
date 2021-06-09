resource "google_compute_router" "default" {
  name    = "${var.name}-router"
  network = var.network
  region  = var.region
}

resource "google_compute_address" "default" {
  count  = length(var.subnets)
  region = var.region
  name   = "${var.name}-ip-${count.index}"
}

resource "google_compute_router_nat" "default" {
  count                  = length(var.subnets)
  name                   = "${var.name}-nat-${count.index}"
  router                 = google_compute_router.default.name
  region                 = google_compute_router.default.region
  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [
    google_compute_address.default[count.index].self_link
  ]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = var.subnets[count.index]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
