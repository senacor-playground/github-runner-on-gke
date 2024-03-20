output "oci_image" {
  value      = local.oci_image
  depends_on = [terraform_data.kubernetes_manifests]
}
