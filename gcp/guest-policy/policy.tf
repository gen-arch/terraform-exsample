# ----------------------------------------------
# Ubuntu Default Policy
# ----------------------------------------------
variable "ubuntu_default_pkg" {
  description = "ubuntu default packages"
  type = list(
    object({
      pkg   = string,
      state = string,
    })
  )
}
variable "ubuntu_default_repo" {
  description = "ubuntu default repository"
  type = list(
    object({
      archive_type = string,
      uri          = string,
      distribution = string,
      components   = list(string),
    })
  )
}
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

# ----------------------------------------------
# Ubuntu Utils Policy
# ----------------------------------------------
variable "ubuntu_utils_pkg" {
  type = list(
    object({
      pkg   = string,
      state = string,
    })
  )
}
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

# ----------------------------------------------
# Ubuntu Container Policy
# ----------------------------------------------
variable "ubuntu_container_pkg" {
  type = list(
    object({
      pkg   = string,
      state = string,
    })
  )
}
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

# ----------------------------------------------
# Ubuntu Configs Policy
# ----------------------------------------------
resource "google_storage_bucket" "is-ito-ubuntu-configs" {
  name     = "is-ito-ubuntu-configs"
  location = "asia-northeast1"
}
# ----------------------------------------------
# google-fluent
# ----------------------------------------------
variable "google-fluent-configs" {}

resource "google_storage_bucket_object" "google-fluent" {
  for_each = var.google-fluent-configs

  name   = each.key
  source = each.value.src
  bucket = google_storage_bucket.is-ito-ubuntu-configs.name
}

resource "google_os_config_guest_policies" "ubuntu-config-google-fluent" {
  for_each = google_storage_bucket_object.google-fluent

  provider        = google-beta
  guest_policy_id = "google-fluent-${each.value.name}"

  assignment {
    os_types {
      os_short_name = "ubuntu"
      os_version    = "20.04"
    }

    group_labels {
      labels = {
        ospolicy-ubuntu-config-google-fluent = "true"
      }
    }
  }

  recipes {
    name          = "google-fluent-${each.value.name}"
    desired_state = "UPDATED"
    version       = tonumber(regex("generation=([0-9]+)", each.value.media_link)[0])

    artifacts {
      id = each.value.name

      gcs {
        bucket     = google_storage_bucket.is-ito-ubuntu-configs.name
        object     = each.value.name
        generation = tonumber(regex("generation=([0-9]+)", each.value.media_link)[0])
      }
    }

    install_steps {
      file_copy {
        artifact_id = each.value.name
        destination = var.google-fluent-configs[each.value.name].dest
        permissions = var.google-fluent-configs[each.value.name].permissions
        overwrite   = true
      }
    }

    update_steps {
      file_copy {
        artifact_id = each.value.name
        destination = var.google-fluent-configs[each.value.name].dest
        permissions = var.google-fluent-configs[each.value.name].permissions
        overwrite   = true
      }
    }
  }
}

