resource "google_service_account" "default" {
  account_id   = "${var.name}-account"
  display_name = var.name
}

resource "google_project_iam_member" "cloud_sql_connection" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_compute_health_check" "default" {
  name                = "${var.name}-hc"
  check_interval_sec  = var.hc.check_interval_sec
  timeout_sec         = var.hc.timeout_sec
  healthy_threshold   = var.hc.healthy_threshold
  unhealthy_threshold = var.hc.unhealthy_threshold

  http_health_check {
    request_path = var.hc.path
    port         = var.hc.port
  }
}

resource "google_compute_instance_template" "default" {
  name                    = "${var.name}-instance-template"
  machine_type            = var.machine_type
  region                  = var.region
  metadata_startup_script = var.startup_script
  metadata = {
    user-data = var.cloud_init
  }

  disk {
    source_image = var.image
  }

  // networking
  network_interface {
    subnetwork = var.subnet
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "mig-${var.name}"
  base_instance_name = var.name
  zone               = var.zone

  version {
    name              = "${var.name}-version"
    instance_template = google_compute_instance_template.default.id
  }

  target_size = var.size

  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = 300
  }
}


#resource "google_compute_autoscaler" "default" {
#  name   = "${var.name}-autoscaler"
#  zone   = var.zone
#  target = google_compute_instance_group_manager.default.id
#
#  autoscaling_policy {
#    max_replicas    = 5
#    min_replicas    = 1
#    cooldown_period = 60
#
#    cpu_utilization {
#      target = 0.6
#    }
#  }
#}
