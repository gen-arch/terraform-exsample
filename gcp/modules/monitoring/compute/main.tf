resource "google_monitoring_alert_policy" "CPU_utilization" {
  display_name = "${var.name}-CPU_utilization is High"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "VM Instance - CPU utilization [MEAN]"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration        = "60s"
      threshold_value = "0.6"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.default.id]
}

resource "google_monitoring_alert_policy" "CPU_utilization_agent" {
  display_name = "${var.name}-CPU_utilization(OS) is High"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "VM Instance - CPU utilization(OS) [MEAN]"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      filter          = "metric.type=\"agent.googleapis.com/cpu/utilization\" resource.type=\"gce_instance\" metric.label.\"cpu_state\"!=\"idle\""
      duration        = "60s"
      threshold_value = "0.6"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.default.id]
}



resource "google_monitoring_notification_channel" "default" {
  display_name = "PagerDuty for ${var.name}"
  type         = "pagerduty"
  labels = {
    "service_key" = var.pagerduty_gcp_key
  }
}

