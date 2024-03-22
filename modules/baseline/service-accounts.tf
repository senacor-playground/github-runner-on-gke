resource "google_service_account" "service_accounts" {
  for_each = toset([
    "external-secrets",
    "config-sync",
    "github-runner-nodes",
    "github-runner"
  ])
  project    = var.project_id
  account_id = each.key
}

resource "google_service_account_iam_member" "workload_identity" {
  for_each = var.skip_workload_identity ? {} : { # Kubernetes SA -> Google SA
    "external-secrets/external-secrets"        = "external-secrets",
    "config-management-system/root-reconciler" = "config-sync",
    "arc-runners/github-runner"                = "github-runner",
  }
  service_account_id = google_service_account.service_accounts[each.value].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.key}]"
}
