output "module_output" {
  value = module.simple_example_static_site
}

output "custom_domain_name" {
  value = local.full_custom_domain_name
}

output "cert_renewal_date" {
  description = "If Terraform apply is run after this date, the TLS cert will be renewed. The ACME provider is internally aware of how many days until the cert expires. The cert will be renewed the next time Terraform is applied within that date interval. So, if schedule Terraform apply periodically, you'll be renewed automatically. See: https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate#min_days_remaining"
  value = timeadd(azurerm_app_service_certificate.custom_hostname.expiration_date, "-${acme_certificate.certificate.min_days_remaining * 24}h")
}

output "cert_expiration_date" {
  description = "Use this to determine whether the cert needs to be renewed"
  value       = azurerm_app_service_certificate.custom_hostname.expiration_date
}
