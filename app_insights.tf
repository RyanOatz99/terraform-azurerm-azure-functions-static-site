resource "azurerm_application_insights" "static_site" {
  count               = var.enable_app_insights ? 1 : 0
  name                = "ai-${var.name}"
  location            = azurerm_resource_group.static_site.location
  resource_group_name = azurerm_resource_group.static_site.name
  application_type    = "other"
}
