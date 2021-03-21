resource "azurerm_app_service_plan" "static_site" {
  name                = "asp-${var.name}"
  location            = azurerm_resource_group.static_site.location
  resource_group_name = azurerm_resource_group.static_site.name
  kind                = "FunctionApp" # You might think this should be Linux...
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

locals {
  now           = timestamp()
  now_timestamp = "${formatdate("YYYY-MM-DD", local.now)}T00:00Z"

  ten_years_from_now_year      = formatdate("YYYY", local.now) + 10
  ten_years_from_now_timestamp = "${local.ten_years_from_now_year}-${formatdate("MM-DD", local.now)}T00:00Z"
}

data "azurerm_storage_account_sas" "package" {
  connection_string = azurerm_storage_account.static_site.primary_connection_string
  https_only        = false
  # local.ten_years_from_now
  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timestamp()

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}

resource "azurerm_function_app" "static_site" {
  name                       = "fn-${var.name}"
  location                   = azurerm_resource_group.static_site.location
  resource_group_name        = azurerm_resource_group.static_site.name
  app_service_plan_id        = azurerm_app_service_plan.static_site.id
  storage_account_name       = azurerm_storage_account.static_site.name
  storage_account_access_key = azurerm_storage_account.static_site.primary_access_key
  os_type                    = "linux"

  version = "~3"
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "FUNCTION_APP_EDIT_MODE"   = "readonly"
    "https_only"               = true
    "sha1"                     = data.archive_file.azure_function_package.output_sha
    "sha256"                   = data.archive_file.azure_function_package.output_base64sha256
    "md5"                      = data.archive_file.azure_function_package.output_md5
    "WEBSITE_RUN_FROM_PACKAGE" = "https://${azurerm_storage_account.static_site.name}.blob.core.windows.net/${azurerm_storage_container.function_packages.name}/${azurerm_storage_blob.function.name}${data.azurerm_storage_account_sas.package.sas}"
  }
  depends_on = [
    azurerm_storage_blob.function,
    data.archive_file.azure_function_package
  ]
}
