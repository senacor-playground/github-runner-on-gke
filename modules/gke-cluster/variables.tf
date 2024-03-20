variable "project_id" {
  type = string
}

variable "gke_cluster_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "nodes_service_account_email" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "config_sync_service_account_email" {
  type = string
}

variable "config_sync_oci_image" {
  type = string
}
