terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.3.0" # Since this isn't a Hashicorp-specific provider, not implicitly trusting patches
    }
  }
}

variable "lets_encrypt_is_prod" {
  description = "Since Let's Encrypt limits the use of their production"
  type        = bool
  default     = false
}

locals {
  lets_encrypt_staging_server = "https://acme-staging-v02.api.letsencrypt.org/directory"
  lets_encrypt_prod_server    = "https://acme-v02.api.letsencrypt.org/directory"
  lets_encrypt_server_url     = var.lets_encrypt_is_prod ? local.lets_encrypt_prod_server : local.lets_encrypt_staging_server
}

provider "acme" {
  server_url = local.lets_encrypt_server_url
}

resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = "jim.andreasen@reifnir.com"
}

variable "azure_client_id" {
  description = "ACME challenge Azure Client ID (think username)"
}

variable "azure_client_secret" {
  description = "ACME challenge Azure Client Secret (think password)"
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "ACME challenge Azure tenant what owns the DNS zone"
}

resource "random_password" "pfx" {
  length = 16
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  key_type                  = "4096"
  common_name               = local.full_custom_domain_name
  subject_alternative_names = [local.full_custom_domain_name]
  certificate_p12_password  = random_password.pfx.result

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
