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

# We're hosting DNS with an Azure DNS zone. You can use any DNS provider, though.
variable "azure_dns_zone_id" {
  description = "The full Azure resource ID for the DNS zone we're using."
}

variable "lets_encrypt_contact_email" {
  description = "value"
}
