variable "oci_repository" {
  type = string
}

variable "manifests_path" {
  type = string
}

variable "env_vars" {
  type    = map(any)
  default = {}
}
