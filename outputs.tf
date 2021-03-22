output "default_hostname" {
  description = "This is the full DNS with TLS that is automatically wired-up by Azure Functions."
  value       = azurerm_function_app.static_site.default_hostname
}

output "custom_domain_txt_record_name" {
  description = "When binding a custom DNS name, this value is the name of the TXT record."
  value       = "asuid.${azurerm_function_app.static_site.name}"
}

output "custom_domain_verification_id" {
  description = "When binding a custom DNS name, this value proves ownership of the domain name."
  value       = azurerm_function_app.static_site.custom_domain_verification_id
}

output "app_service_name" {
  description = "When binding a custom DNS name, this is the value required for `azurerm_app_service_custom_hostname_binding.app_service_name`. Note: app_service_name doesn't mean app service plan name."
  value       = azurerm_function_app.static_site.name
}

output "resource_group_name" {
  description = "Resource group that will house any Azure resources created in this module."
  value       = azurerm_resource_group.static_site.name
}

output "location" {
  description = "Azure region in which all resources are created"
  value       = var.location
}
