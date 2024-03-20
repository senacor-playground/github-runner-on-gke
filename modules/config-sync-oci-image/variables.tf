variable "oci_image" {
  type = string
}

variable "helm_chart_path" {
  type = string
}

variable "values" {
  type    = map(any)
  default = {}
}
