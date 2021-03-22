terraform {
  backend "azurerm" {
    resource_group_name  = "rg-common-storage"
    storage_account_name = "sareifnircommonstorage"
    container_name       = "terraform-state"
    key                  = "terraform-azurerm-azure-functions-static-site-some-custom-dns.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# We're hosting DNS with an Azure DNS zone. You can use any DNS provider, though.
variable "azure_dns_zone_id" {
  description = "The full Azure resource ID for the DNS zone we're using."
}

resource "random_string" "name_suffix" {
  length  = 4
  number  = true
  lower   = true
  upper   = false
  special = false
}

locals {
  # Hostname is everything more specific than the domain or TLD. See: https://techterms.com/definition/fqdn
  # We want to host our static site at 'some-custom-dns-1a6z.somedomain.com'
  dns_hostname                 = "some-custom-dns-${random_string.name_suffix.result}"
  full_custom_domain_name      = "${local.dns_hostname}.${data.azurerm_dns_zone.custom.name}"
  dns_zone_subscription_id     = split("/", var.azure_dns_zone_id)[2]
  dns_zone_name                = split("/", var.azure_dns_zone_id)[8]
  dns_zone_resource_group_name = split("/", var.azure_dns_zone_id)[4]

  azure_function_name = "custom-dns-example"

  tags = {
    "Application" = "Simple example static site with a custom DNS entry"
    "ManagedBy"   = "Terraform"
  }
}

# Magic up the static site...
module "simple_example_static_site" {
  source                   = "../../"
  name                     = local.azure_function_name
  static_content_directory = "${path.root}/static-content"
  tags                     = local.tags
}
