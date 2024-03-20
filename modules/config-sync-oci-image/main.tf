resource "terraform_data" "kubernetes_manifests" {
  triggers_replace = [
    sha256(join("", [for f in fileset(".", "${var.helm_chart_path}/**") : "${f}:${filebase64sha256(f)}"])),
    sha256(jsonencode(var.values)),
    9, # Change this to force rerun script
  ]

  provisioner "local-exec" {
    command = <<-EOT
      TMP_DIR=$(mktemp -d)

      mkdir -p "$TMP_DIR/charts/root-sync"
      touch "$TMP_DIR/charts/root-sync/values.yaml"
      cp -r "$HELM_CHART_PATH"/* "$TMP_DIR/charts/root-sync"

      echo "$VALUES" > "$TMP_DIR/values.yaml"
      cp "$MODULE_PATH/kustomization.yaml" "$TMP_DIR/kustomization.yaml"

      tar -C "$TMP_DIR" -c . | crane append -f - -t $OCI_IMAGE

      rm -r "$TMP_DIR"
      EOT

    environment = {
      HELM_CHART_PATH = var.helm_chart_path
      MODULE_PATH     = path.module
      OCI_IMAGE       = var.oci_image
      VALUES          = jsonencode(var.values)
    }
  }
}
