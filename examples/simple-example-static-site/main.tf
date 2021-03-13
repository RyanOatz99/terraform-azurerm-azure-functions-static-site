terraform {
  backend "azurerm" {
    # Relies on environment variables for configuration
    resource_group_name  = "rg-common-storage"
    storage_account_name = "sareifnircommonstorage"
    container_name       = "terraform-state"
    key                  = "terraform-azurerm-azure-functions-static-site-examples.tfstate"
  }
}

module "simple-example-static-site" {
  source = "../../"
}