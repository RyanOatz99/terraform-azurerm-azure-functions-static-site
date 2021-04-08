terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.3.0" # Since this isn't a Hashicorp-specific provider, not implicitly trusting patches
    }
  }
}

provider "acme" {
  # You cannot attach a let's encrypt staging cert to an app in Azure, you get a BadRequest 04038 error: Expired certificate is not allowed.
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = var.lets_encrypt_contact_email
}

resource "random_password" "pfx" {
  length = 16
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  key_type                  = "4096"
  common_name               = local.full_custom_domain_name
  subject_alternative_names = [local.full_custom_domain_name]
  certificate_p12_password  = random_password.pfx.result
  min_days_remaining        = 30

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_CLIENT_ID       = var.azure_client_id
      AZURE_CLIENT_SECRET   = var.azure_client_secret
      AZURE_SUBSCRIPTION_ID = local.dns_zone_subscription_id
      AZURE_TENANT_ID       = var.azure_tenant_id
      AZURE_ENVIRONMENT     = "public"
      AZURE_RESOURCE_GROUP  = local.dns_zone_resource_group_name
    }
  }
  depends_on = [azurerm_dns_cname_record.some_custom_dns]
}

resource "azurerm_app_service_certificate" "custom_hostname" {
  name                = local.dns_hostname
  resource_group_name = module.simple_example_static_site.resource_group_name
  location            = module.simple_example_static_site.location
  pfx_blob            = acme_certificate.certificate.certificate_p12
  password            = acme_certificate.certificate.certificate_p12_password
  depends_on          = [acme_certificate.certificate]
}

resource "azurerm_app_service_certificate_binding" "custom_hostname" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.static_site.id
  certificate_id      = azurerm_app_service_certificate.custom_hostname.id
  ssl_state           = "SniEnabled"
}
