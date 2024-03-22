resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = "beppo"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each = {
    "github-runner-gke-cluster" = {
      region              = "europe-west4"
      ip_cidr_range       = "10.0.0.0/28"
      secondary_ip_ranges = { "pods" = "10.1.0.0/20", "services" = "10.2.0.0/25" }
    }
  }
  project = var.project_id
  name    = each.key
  region  = each.value.region

  network = google_compute_network.default.id

  ip_cidr_range = each.value.ip_cidr_range

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}
