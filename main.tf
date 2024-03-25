module "baseline" {
  source     = "./modules/baseline"
  project_id = var.project_id
}

module "config_sync_oci_image" {
  source         = "./modules/config-sync-oci-image"
  oci_repository = "europe-docker.pkg.dev/senacor-playground/beppo-repo/cluster-root-sync/github-runners"
  manifests_path = "kubernetes-manifests"
  env_vars = {
    EXTERNAL_SECRETS_SERVICE_ACCOUNT_EMAIL = module.baseline.service_account_emails["external-secrets"]
    SECRET_MANAGER_PROJECT_ID              = var.project_id
  }
}

module "gke_cluster" {
  source                            = "./modules/gke-cluster"
  project_id                        = var.project_id
  gke_cluster_name                  = "github-runners"
  region                            = "europe-west4"
  zone                              = "europe-west4-a"
  nodes_service_account_email       = module.baseline.service_account_emails["github-runner-nodes"]
  network_id                        = module.baseline.network_id
  subnet_id                         = module.baseline.subnet_ids["github-runner-gke-cluster"]
  master_ipv4_cidr_block            = "10.5.0.0/28"
  config_sync_service_account_email = module.baseline.service_account_emails["config-sync"]
  config_sync_oci_image             = module.config_sync_oci_image.oci_image

  depends_on = [module.baseline]
}
