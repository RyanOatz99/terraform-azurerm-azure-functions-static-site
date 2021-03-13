terraform {
  # Only testing with 0.14 for now
  required_version = "~> 0.14"
  required_providers {
    azurerm = {
      # Only testing with azurerm provider 2, need to test before being used in 3
      version = "~> 2"
    }
  }
}

variable "static_content_directory" {
  description = "This is the path to the directory containing static resources."
}

resource "null_resource" "package_build" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter =  [ "/bin/bash", "-c" ]
    command     = "${path.module}/scripts/build-package.sh \"${var.static_content_directory}\""
  }
}
