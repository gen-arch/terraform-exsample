variable "ubuntu_default_pkg" {}
variable "ubuntu_default_repo" {}
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

  dynamic "packages" {
    for_each = var.ubuntu_default_pkg
    content {
      name          = packages.value.pkg
      desired_state = packages.value.state
    }
  }

  dynamic "package_repositories" {
    for_each = var.ubuntu_default_repo

    content {
      apt {
        uri          = package_repositories.value.uri
        archive_type = package_repositories.value.archive_type
        distribution = package_repositories.value.distribution
        components   = package_repositories.value.components
      }
    }
  }
}

variable "ubuntu_utils_pkg" {}
resource "google_os_config_guest_policies" "ubuntu-utils-policy" {
  provider        = google-beta
  guest_policy_id = "ubuntu-utils-policy"

  assignment {
    os_types {
      os_short_name = "ubuntu"
      os_version    = "20.04"
    }

    group_labels {
      labels = {
        ospolicy-ubuntu-utils = "true"
      }
    }
  }

  dynamic "packages" {
    for_each = var.ubuntu_utils_pkg
    content {
      name          = packages.value.pkg
      desired_state = packages.value.state
    }
  }
}

variable "ubuntu_container_pkg" {}
resource "google_os_config_guest_policies" "ubuntu-container-policy" {
  provider        = google-beta
  guest_policy_id = "ubuntu-container-policy"

  assignment {
    os_types {
      os_short_name = "ubuntu"
      os_version    = "20.04"
    }

    group_labels {
      labels = {
        ospolicy-ubuntu-container = "true"
      }
    }
  }

  dynamic "packages" {
    for_each = var.ubuntu_container_pkg
    content {
      name          = packages.value.pkg
      desired_state = packages.value.state
    }
  }
}
