# terraform-azurerm-azure-functions-static-site

[![LICENSE](https://img.shields.io/github/license/reifnir/terraform-azurerm-azure-functions-static-site)](https://github.com/reifnir/terraform-azurerm-azure-functions-static-site/blob/master/LICENSE)

## TODO before publishing on Terraform public registry as 1.0.0

* Explicitly point out this is a consumption plan account (minor cold start) in this file

* Consider adding premium function capability

* Remove explicit references to 0.15 beta and bump module minimum version to 0.15

* Wire up [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)

* Automate testing

* Actually use it on waaaaaaaaaay-out-of-date resume site

* Add automatic renewal of Let's Encrypt cert

* Take options for more than one default page name

* Take more than one DNS provider (Azure DNS, Route 53, Cloudflare, etc.) See: [Module Composition#Multi-cloud Abstractions](https://www.terraform.io/docs/language/modules/develop/composition.html#multi-cloud-abstractions)
  * Probably not going to build this into the module as it relies on a non-hashicorp provider for Let's Encrypt generation.

<!--## Assumptions-->

## Important note

_AKA Give it a minute..._

Azure Functions can take a couple of minutes to start working after deployment.
You may receive http responses such as `The service is unavailable.`, however, you just need to give it a few minutes.

Application Insights also takes a few minutes before it starts showing results (aka even looks like it's working).

<!--## Usage example-->
<!--## Conditional creation-->
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

_*auto populated information_

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
