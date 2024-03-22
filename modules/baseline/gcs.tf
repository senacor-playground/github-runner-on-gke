resource "google_storage_bucket" "github_runners_tool_cache" {
  project                     = var.project_id
  name                        = "github-runners-tool-cache-${var.project_id}"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "github_runners_can_write_tool_cache" {
  bucket = google_storage_bucket.github_runners_tool_cache.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.service_accounts["github-runner"].email}"
}
