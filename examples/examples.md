# Examples

[Source](https://www.terraform.io/docs/language/modules/develop/structure.html)

Examples of using the module should exist under the examples/ subdirectory at the root of the repository. Each example may have a README to explain the goal and usage of the example. Examples for submodules should also be placed in the root examples/ directory.
Because examples will often be copied into other repositories for customization, any module blocks should have their source set to the address an external caller would use, not to a relative path.

A minimal recommended module following the standard structure is shown below. While the root module is the only required element, we recommend the structure below as the minimum:

```
$ tree minimal-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

A complete example of a module following the standard structure is shown below. This example includes all optional elements and is therefore the most complex a module can become:

```
$ tree complete-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```