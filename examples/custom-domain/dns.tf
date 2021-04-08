data "azurerm_dns_zone" "custom" {
  name                = local.dns_zone_name
  resource_group_name = local.dns_zone_resource_group_name
}

resource "azurerm_dns_cname_record" "some_custom_dns" {
  name                = local.dns_hostname
  zone_name           = data.azurerm_dns_zone.custom.name
  resource_group_name = data.azurerm_dns_zone.custom.resource_group_name
  ttl                 = 30
  record              = module.simple_example_static_site.default_hostname
  tags                = local.tags
}

resource "azurerm_dns_txt_record" "some_custom_dns_domain_verification" {
  name                = module.simple_example_static_site.custom_domain_txt_record_name
  zone_name           = data.azurerm_dns_zone.custom.name
  resource_group_name = data.azurerm_dns_zone.custom.resource_group_name
  ttl                 = 30

  record {
    value = module.simple_example_static_site.custom_domain_verification_id
  }

  # This is a race condition, consider adding a script that waits until the expected TXT record can be found
  # If this blows up, just increase the durationor rerun apply
  provisioner "local-exec" {
    command = "sleep 10s"
  }
}

resource "azurerm_app_service_custom_hostname_binding" "static_site" {
  hostname            = local.full_custom_domain_name
  app_service_name    = module.simple_example_static_site.app_service_name
  resource_group_name = module.simple_example_static_site.resource_group_name
  depends_on          = [azurerm_dns_txt_record.some_custom_dns_domain_verification]
}
