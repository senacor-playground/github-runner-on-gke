resource "google_container_cluster" "default" {
  project                   = var.project_id
  name                      = var.gke_cluster_name
  location                  = var.zone
  initial_node_count        = 1
  default_max_pods_per_node = 16
  network                   = var.network_id
  subnetwork                = var.subnet_id
  deletion_protection       = false
  remove_default_node_pool  = true

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  release_channel {
    channel = "REGULAR"
  }

  cluster_autoscaling {
    enabled = true
    auto_provisioning_defaults {
      disk_type       = "pd-ssd"
      disk_size       = 10
      image_type      = "COS_CONTAINERD"
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
      service_account = var.nodes_service_account_email

      management {
        auto_repair  = true
        auto_upgrade = true
      }
    }

    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 16
    }

    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 32000
    }

  }

  fleet {
    project = var.project_id
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_gke_hub_feature_membership" "default" {
  project  = var.project_id
  location = "global"
  feature  = "configmanagement"

  membership          = google_container_cluster.default.fleet.0.membership_id
  membership_location = google_container_cluster.default.fleet.0.membership_location

  configmanagement {
    config_sync {
      source_format = "unstructured"
      oci {
        sync_repo                 = var.config_sync_oci_image
        sync_wait_secs            = "20"
        secret_type               = "gcpserviceaccount"
        gcp_service_account_email = var.config_sync_service_account_email
      }
    }
  }

  lifecycle {
    replace_triggered_by = [google_container_cluster.default.id]
  }
}
