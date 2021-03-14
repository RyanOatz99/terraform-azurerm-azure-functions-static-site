terraform {
  backend "azurerm" {
    # Relies on environment variables for configuration
    resource_group_name  = "rg-common-storage"
    storage_account_name = "sareifnircommonstorage"
    container_name       = "terraform-state"
    key                  = "terraform-azurerm-azure-functions-static-site-simple-example-static-site.tfstate"
  }
}

module "simple_example_static_site" {
  source = "../../"
  name = "simple-example-static-site"
  static_content_directory = "${path.root}/static-content"
  tags = {
    "Application" = "Simple example static site"
    "ManagedBy" = "Terraform"
  }
}

# output "debug" {
#   value = module.simple_example_static_site
# }
