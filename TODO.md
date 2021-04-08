## TODO

* Code generation for variables and outputs

* Consider adding premium function capability

* Wire up [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)

* Actually use it on waaaaaaaaaay-out-of-date resume site

* Take options for more than one default page name

* Take more than one DNS provider (Azure DNS, Route 53, Cloudflare, etc.) See: [Module Composition#Multi-cloud Abstractions](https://www.terraform.io/docs/language/modules/develop/composition.html#multi-cloud-abstractions)
  
  * Probably not going to build this into the module as it relies on a non-hashicorp provider for Let's Encrypt generation.
