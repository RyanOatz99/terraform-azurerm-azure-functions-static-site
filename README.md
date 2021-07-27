# terraform-azurerm-azure-functions-static-site

[![LICENSE](https://img.shields.io/github/license/reifnir/terraform-azurerm-azure-functions-static-site)](https://github.com/reifnir/terraform-azurerm-azure-functions-static-site/blob/master/LICENSE)

**BEFORE YOU USE THIS...** I've made another module that doesn't require any C# code, compilation or artifacts (as that can seem fishy to folk). It's located here at [https://registry.terraform.io/modules/reifnir/static-site/azurerm](https://registry.terraform.io/modules/reifnir/static-site/azurerm).

This Terraform module stands up an Azure Functions website that hosts static content.
It does this by building a C# .NET Core 3.1 Azure Functions package with the static contents hosted inside.

The C# code is located within this repo [here](https://github.com/reifnir/terraform-azurerm-azure-functions-static-site/tree/main/function). 

The type of Azure Functions application is a consumption-based plan. This means that after enough time passes without receiving any HTTP requests, the next call can take a couple of seconds to spin up. The larger the size of the static contents, the longer this will take.

If you have interest in this working for Premium Functions (aka at least one execution instance always running, thus no cold-starts), make an issue in the repo.

## Pre-requisites

The machine executing Terraform must have .NET 3.1 SDK's `dotnet` CLI available in PATH.

Ex:
```bash
$ dotnet --list-sdks
3.1.407 [/usr/share/dotnet/sdk]
5.0.202 [/usr/share/dotnet/sdk]
```

<!--## Assumptions-->

## Important note

_AKA Give it a minute..._

Azure Functions can take a couple of minutes to start working after deployment.
You may receive http responses such as `The service is unavailable.`, however, you just need to wait a little.

Application Insights also takes a few minutes before it starts showing results (aka even looks like it's working).

## Usage example
 
 See examples [here](https://github.com/reifnir/terraform-azurerm-azure-functions-static-site/tree/main/examples)

Basic example

 ```terraform
module "content_types" {
  source = "../../"
  name                     = "my-static-site"
  static_content_directory = "${path.root}/static-content"
  enable_app_insights      = false
}
 ```

<!--## Other documentation-->

<!--## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with `go get github.com/segmentio/terraform-docs` or `brew install terraform-docs`.
-->

<!--## Contributing-->
<!--## Change log-->

## Author

Created and maintained by Jim Andreasen.

[github.com/reifnir](https://github.com/reifnir)

[gitlab.com/jim.andreasen](https://gitlab.com/jim.andreasen)

jim.andreasen@reifnir.com

### Inspired by

Anthony Chu's 2017 post [Serving Static Files from Azure Functions](https://anthonychu.ca/post/azure-functions-static-file-server/)

## License

MIT Licensed. See [LICENSE](https://github.com/reifnir/terraform-azurerm-azure-functions-static-site/blob/main/LICENSE) for full details.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.15 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_plan.static_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) | resource |
| [azurerm_application_insights.static_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_function_app.static_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app) | resource |
| [azurerm_resource_group.static_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.static_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.function_packages](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [local_file.script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.package_build](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.storage_account_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [archive_file.azure_function_package](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [azurerm_storage_account_sas.package](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_sas) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_app_insights"></a> [enable\_app\_insights](#input\_enable\_app\_insights) | App Insights isn't free. If you don't want App Insights attached to this site, set this value to false. You can always enable it later if you need to troubleshoot something. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which resources will be located | `string` | `"eastus"` | no |
| <a name="input_name"></a> [name](#input\_name) | Slug is added to the name of most resources | `string` | n/a | yes |
| <a name="input_static_content_directory"></a> [static\_content\_directory](#input\_static\_content\_directory) | This is the path to the directory containing static resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_name"></a> [app\_service\_name](#output\_app\_service\_name) | When binding a custom DNS name, this is the value required for `azurerm_app_service_custom_hostname_binding.app_service_name`. Note: app\_service\_name doesn't mean app service plan name. |
| <a name="output_custom_domain_txt_record_name"></a> [custom\_domain\_txt\_record\_name](#output\_custom\_domain\_txt\_record\_name) | When binding a custom DNS name, this value is the name of the TXT record. |
| <a name="output_custom_domain_verification_id"></a> [custom\_domain\_verification\_id](#output\_custom\_domain\_verification\_id) | When binding a custom DNS name, this value proves ownership of the domain name. |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | This is the full DNS with TLS that is automatically wired-up by Azure Functions. |
| <a name="output_location"></a> [location](#output\_location) | Azure region in which all resources are created |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group that will house any Azure resources created in this module. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
