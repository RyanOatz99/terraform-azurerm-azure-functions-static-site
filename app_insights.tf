resource "azurerm_application_insights" "static_site" {
  name                = "ai-${var.name}"
  location            = azurerm_resource_group.static_site.location
  resource_group_name = azurerm_resource_group.static_site.name
  application_type    = "other"
}
