resource "google_artifact_registry_repository_iam_member" "github_runner_nodes_can_read_images" {
  project    = var.project_id
  location   = "europe"
  repository = "beppo-repo"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.service_accounts["github-runner-nodes"].email}"
}
