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
