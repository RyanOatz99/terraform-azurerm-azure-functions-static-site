# Until/unless Terraform provides a simpler `path.temp` capability, this is a workaround for creating
#   A temporary directory
#   That does not get cleaned-up after multiple jobs (boo)
#   With no possibility of file collissions for previous builds
# See: https://github.com/hashicorp/terraform/issues/21308#issuecomment-721478826
locals {
  temp_dir                  = "${path.root}/.terraform/tmp/build-${local.now_friendly}"
  temp_package_contents_dir = "${local.temp_dir}/package"
  temp_package_zip_path     = "${local.temp_dir}/package.zip"
}

resource "local_file" "script" {
  content  = "This is just a placeholder that creates the necessary temporary directory"
  filename = "${local.temp_dir}/place-holder.txt"
}

resource "null_resource" "package_build" {
  triggers = {
    always_run = local.now
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/scripts/build-package.sh --static-content-dir=\"${var.static_content_directory}\" --temp-dir=\"${local.temp_dir}\""
  }
}

data "archive_file" "azure_function_package" {
  type        = "zip"
  source_dir  = local.temp_package_contents_dir
  output_path = local.temp_package_zip_path
  depends_on  = [null_resource.package_build]
}

resource "azurerm_storage_blob" "function" {
  name                   = "fn-${local.now_friendly}.zip"
  storage_account_name   = azurerm_storage_account.static_site.name
  storage_container_name = azurerm_storage_container.function_packages.name
  type                   = "Block"
  metadata = {
    sha1   = data.archive_file.azure_function_package.output_sha
    sha256 = data.archive_file.azure_function_package.output_base64sha256
    md5    = data.archive_file.azure_function_package.output_md5
  }
  source = data.archive_file.azure_function_package.output_path
}
