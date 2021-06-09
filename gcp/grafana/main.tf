data "google_secret_manager_secret_version" "password" {
  secret = "example-pass"
}

resource "google_service_account" "grafana" {
  account_id   = "grafana"
  display_name = "grafana"
}

resource "google_cloud_run_service_iam_binding" "grafana" {
  service  = google_cloud_run_service.grafana_service.name
  location = google_cloud_run_service.grafana_service.location
  project  = google_cloud_run_service.grafana_service.project
  role     = "roles/run.invoker"

  members = [
    "allUsers"
  ]
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  ip_cidr_range = "10.8.0.0/28"
  network       = module.network.network.name
}

resource "google_cloud_run_service" "grafana_service" {
  name     = "grafana"
  location = "asia-northeast1"
  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "internal-and-cloud-load-balancing"
      "run.googleapis.com/ingress-status" = "internal-and-cloud-load-balancing"
    }
  }

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "5"
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
      }
    }
    spec {
      service_account_name = google_service_account.grafana.email
      containers {
        image = "marketplace.gcr.io/google/grafana7"
        env {
          name  = "GF_SERVER_HTTP_PORT"
          value = 8080
        }
        env {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = data.google_secret_manager_secret_version.password.secret_data
        }
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "grafana_neg" {
  name                  = "grafana-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-northeast1"
  cloud_run {
    service = google_cloud_run_service.grafana_service.name
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "test-cert"
  managed {
    domains = ["test.archgen.net."]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "example" {
  name       = "example"
  target     = google_compute_target_https_proxy.default.self_link
  ip_address = var.gip
  port_range = "443"
}

resource "google_compute_url_map" "default" {
  name            = "default"
  default_service = google_compute_backend_service.grafana.self_link
}

resource "google_compute_backend_service" "grafana" {
  name = "grafana"

  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.grafana_neg.id
  }
  security_policy = google_compute_security_policy.default.id
}

