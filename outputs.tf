output "debug" {
  value = {
    azure_function               = azurerm_function_app.static_site
    app_service_plan             = azurerm_app_service_plan.static_site
    storage_account              = azurerm_storage_account.static_site
    container                    = azurerm_storage_container.function_packages
    blob                         = azurerm_storage_blob.function
    now_timestamp                = local.now_timestamp
    ten_years_from_now_timestamp = local.ten_years_from_now_timestamp
  }
}
