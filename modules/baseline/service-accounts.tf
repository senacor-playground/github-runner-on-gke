resource "google_service_account" "service_accounts" {
  for_each = {
    "external-secrets"    = "Syncs secrets into GKE cluster from Secret Manager",
    "config-sync"         = "Deploys resources into GKE cluster via GitOps"
    "github-runner-nodes" = "For GKE worker node VMs"
  }
  project    = var.project_id
  account_id = "${var.name}-${each.key}"
}

resource "google_service_account_iam_member" "workload_identity" {
  for_each = var.skip_workload_identity ? {} : { # Kubernetes SA -> Google SA
    "external-secrets/external-secrets"        = "external-secrets",
    "config-management-system/root-reconciler" = "config-sync",
  }
  service_account_id = google_service_account.service_accounts[each.value].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.key}]"
}
