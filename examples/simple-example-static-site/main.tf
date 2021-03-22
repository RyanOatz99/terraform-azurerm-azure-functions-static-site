terraform {

  # If you're new to Terraform and just want to try this module out for yourself, remove this 'backend' block and your
  # state will be stored locally.
  backend "azurerm" {
    resource_group_name  = "rg-common-storage"
    storage_account_name = "sareifnircommonstorage"
    container_name       = "terraform-state"
    key                  = "terraform-azurerm-azure-functions-static-site-simple-example-static-site.tfstate"
  }
}

resource "random_string" "name_suffix" {
  lower   = true
  number  = true
  upper   = false
  special = false
  length  = 8
}

module "simple_example_static_site" {
  source                   = "../../"
  name                     = "simple-example-static-site-${random_string.name_suffix.result}"
  static_content_directory = "${path.root}/static-content"
  tags = {
    "Application" = "Simple example static site"
    "ManagedBy"   = "Terraform"
  }
}

# output "debug" {
#   value = module.simple_example_static_site
# }
