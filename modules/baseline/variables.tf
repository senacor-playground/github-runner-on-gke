variable "project_id" {
  type = string
}

variable "skip_workload_identity" {
  description = "The workload identity pool only exists after first GKE cluster was created"
  type        = bool
  default     = false
}
