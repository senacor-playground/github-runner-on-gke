resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthos.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_gke_hub_feature" "configmanagement" {
  name       = "configmanagement"
  project    = var.project_id
  location   = "global"
  depends_on = [google_project_service.services["anthosconfigmanagement.googleapis.com"]]
}
