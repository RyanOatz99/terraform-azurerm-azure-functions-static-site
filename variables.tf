variable "name" {
  type = string
  description = "Slug is added to the name of most resources"
}

variable "location" {
  type = string
  description = "Azure region in which resources will be located"
  default     = "eastus"
}

variable "static_content_directory" {
  type = string
  description = "This is the path to the directory containing static resources."
}

variable "tags" {
  type = map
  default = {
    "ManagedBy" = "Terraform"
  }
}
