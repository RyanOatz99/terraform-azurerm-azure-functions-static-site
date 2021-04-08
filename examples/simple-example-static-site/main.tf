provider "azurerm" {
  features {}
}

resource "random_string" "name_suffix" {
  lower   = true
  number  = true
  upper   = false
  special = false
  length  = 8
}

# Remember, the name of an Azure Functions application must be unique across all customers since that's part of the
# default hostname. That's why we're adding the random string.
module "simple_example_static_site" {
  source                   = "../../"
  name                     = "simple-example-static-site-${random_string.name_suffix.result}"
  static_content_directory = "${path.root}/static-content"
  enable_app_insights      = true
  tags = {
    "Application" = "Simple example static site"
    "ManagedBy"   = "Terraform"
  }
}

output "module_output" {
  value = module.simple_example_static_site
}
