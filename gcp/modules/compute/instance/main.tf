resource "google_service_account" "default" {
  account_id   = var.name
  display_name = var.name
}

resource "google_project_iam_member" "monitoring" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "logwriter" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  network_interface {
    subnetwork = var.subnet
    network_ip = var.ip
    #access_config {
    #  nat_ip = var.nat_ip
    #}
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    user-data       = var.cloud_init
    startup-script  = var.startup_script
    enable-osconfig = "TRUE"
  }
  labels = var.labels
}
