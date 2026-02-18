# Used commands for the workshop

Listing state: `terraform state list`
Viewing a specific resource: `terraform state show random_id.server`
Moving a resource (renaming): `terraform state mv local_file.foo local_file.bar`
State refresh: `terraform refresh`

# Other commands you could use 
In the workshop we used removed and import blocks. The reason we did this is that it's not always as easy to use the Terraform CLI, in cases where the CI/CD is primarily used for terraform operations using these blocks will still allow you to manipulate the state without having CLI access.

Removing a resource from state `terraform state remove local_file.foo`
Importing a resource into the state `terraform import random_id.server KrxuGtwgAZw`