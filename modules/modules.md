# Nested modules

[Source](https://www.terraform.io/docs/language/modules/develop/structure.html)

Nested modules. Nested modules should exist under the modules/ subdirectory. Any nested module with a README.md is
considered usable by an external user. If a README doesn't exist, it is considered for internal use only. These are
purely advisory; Terraform will not actively deny usage of internal modules. Nested modules should be used to split
complex behavior into multiple small modules that advanced users can carefully pick and choose. For example, the Consul
module has a nested module for creating the Cluster that is separate from the module to setup necessary IAM policies.
This allows a user to bring in their own IAM policy choices.

If the root module includes calls to nested modules, they should use relative paths like ./modules/consul-cluster so
that Terraform will consider them to be part of the same repository or package, rather than downloading them again
separately.
