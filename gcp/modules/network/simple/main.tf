resource "google_compute_network" "default" {
  name                    = var.name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.name}-subnet"
  ip_cidr_range            = var.cidr
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_firewall" "iap" {
  name          = "example-allow-ingress-from-iap"
  network       = google_compute_network.default.self_link
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "health-check" {
  name      = "example-allow-ingress-hc"
  network   = google_compute_network.default.self_link
  direction = "INGRESS"
  priority  = 1001
  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
  ]
  allow {
    protocol = "tcp"
    ports    = ["80", "9292", "8000"]
  }
}

