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

provider "azurerm" {
  features {}
}

locals {
  resource_group_name             = "rg-${var.name}-static-function"
  name_without_special_char       = replace(var.name, "/[^\\w]*/", "")
  # Storage account names constraints:
  #   contain numbers and lowercase letters
  #   be from 3 to 24 characters long ("sa" + max of 14 characters from name + 8 random == 24)
  #   must be unique across all storage accounts as they are given a unique public DNS name
  storave_account_name_slug       = substr(lower(local.name_without_special_char), 0, 14)
  storage_account_name            = "sa${local.storave_account_name_slug}${random_string.storage_account_name.result}"
  function_package_container_name = "${var.name}-static-site-az-fn-packages"
}

resource "azurerm_resource_group" "static_site" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "random_string" "storage_account_name" {
  lower   = true
  number  = true
  upper   = false
  special = false
  length  = 8
}

resource "azurerm_storage_account" "static_site" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.static_site.name
  location                 = azurerm_resource_group.static_site.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "function_packages" {
  name                  = local.function_package_container_name
  storage_account_name  = azurerm_storage_account.static_site.name
  container_access_type = "private"
}
