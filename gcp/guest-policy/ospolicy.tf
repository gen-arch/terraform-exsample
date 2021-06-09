resource "google_os_config_guest_policies" "ubuntu-default-policy" {
  provider        = google-beta
  guest_policy_id = "ubuntu-default-policy"

  assignment {
    os_types {
      os_short_name = "ubuntu"
      os_version    = "20.04"
    }

    group_labels {
      labels = {
        ospolicy-ubuntu = "true"
      }
    }
  }

  packages {
    name          = "google-fluentd"
    desired_state = "INSTALLED"
  }

  packages {
    name          = "stackdriver-agent=6.1.3-1.focal"
    desired_state = "INSTALLED"
  }

  packages {
    name          = "google-fluentd-catch-all-config-structured"
    desired_state = "INSTALLED"
  }

  packages {
    name          = "google-fluentd-catch-all-config"
    desired_state = "REMOVED"
  }

  package_repositories {
    apt {
      uri          = "https://packages.cloud.google.com/apt"
      archive_type = "DEB"
      distribution = "google-cloud-monitoring-focal"
      components   = ["main"]
    }
  }

  package_repositories {
    apt {
      uri          = "https://packages.cloud.google.com/apt"
      archive_type = "DEB"
      distribution = "google-cloud-logging-focal"
      components   = ["main"]
    }
  }
}
