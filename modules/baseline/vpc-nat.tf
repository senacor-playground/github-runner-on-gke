resource "google_compute_router" "default" {
  project = var.project_id
  name    = "beppo"
  region  = "europe-west4"
  network = google_compute_network.default.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "beppo"
  router                             = google_compute_router.default.name
  region                             = google_compute_router.default.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
