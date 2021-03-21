resource "null_resource" "package_build" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/scripts/build-package.sh \"${var.static_content_directory}\""
  }
}

locals {
  temp_package_contents_dir    = "${path.module}/.temp/package"
  azure_functions_package_path = "${path.module}/.temp/package-${local.now_timestamp}.zip"
}

data "archive_file" "azure_function_package" {
  type        = "zip"
  source_dir  = local.temp_package_contents_dir
  output_path = local.azure_functions_package_path
  depends_on  = [null_resource.package_build]
}

resource "azurerm_storage_blob" "function" {
  name                   = "fn-${local.now_timestamp}.zip"
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
