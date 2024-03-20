locals {
  hash = sha256(jsonencode([
    [for f in fileset(".", "${var.manifests_path}/**") : "${f}:${filebase64sha256(f)}"],
    sha256(jsonencode(var.env_vars)),
    var.oci_repository,
    5
  ]))
  oci_image = "${var.oci_repository}:build-${substr(local.hash, 0, 10)}"
}

resource "terraform_data" "kubernetes_manifests" {
  triggers_replace = local.oci_image

  provisioner "local-exec" {
    command = <<-EOT
      TMP_DIR="$(mktemp -d)"

      cp -r * "$TMP_DIR"
      for file in $(find . -type f -name "*.yaml"); do
        if echo "$file" | grep -q "charts/"; then
          continue
        fi
        mkdir -p "$TMP_DIR/$(dirname $file)"
        cat $file | envsubst > "$TMP_DIR/$file"
      done

      tar -C "$TMP_DIR" -c . | crane append -f - -t "$OCI_IMAGE"
      crane copy "$OCI_IMAGE" "$OCI_REPOSITORY:latest"

      rm -r "$TMP_DIR"
      EOT

    working_dir = var.manifests_path

    environment = merge(var.env_vars, {
      OCI_IMAGE      = local.oci_image
      OCI_REPOSITORY = var.oci_repository
    })
  }
}
