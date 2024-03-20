output "service_account_emails" {
  value = { for k, v in google_service_account.service_accounts : k => v.email }
}

output "network_id" {
  value = google_compute_network.default.id
}

output "subnet_ids" {
  value = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}
