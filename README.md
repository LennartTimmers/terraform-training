# Terraform training

Workshop material for learning Terraform, from the basics up to a multi-environment Azure setup.
Each part is a separate root module: `cd` into the folder and run the commands there.

| Folder | Topic | Providers | Needs cloud access |
|---|---|---|---|
| [`part 1`](part%201/) | Variables, locals, `for_each`, `for` expressions, set/map functions | local | No |
| [`part_2_state`](part_2_state/) | Working with state: `state` commands, `import` and `removed` blocks, data sources | local, random | No |
| [`part_4`](part_4/) | A realistic Azure project duplicated per environment (dev/test/prod) | azurerm, datadog, random | No (read and validate only) |
| [`part_5`](part_5/) | Minimal module with a variable and outputs | local | No |

## Prerequisites

- Terraform 1.10 or newer (part 4 requires `>= 1.10`, the others work with older versions).
- No credentials are needed for parts 1, 2 and 5: they only create files on your machine.

## Basic workflow

```sh
cd part_5
terraform init
terraform plan
terraform apply
terraform destroy
```

Note that `part 1` contains a space, so quote it: `cd "part 1"`.

## Part 1: variables, locals and loops

Works with a map of fruits, defined both as a variable (`variables.auto.tfvars`) and as a local
(`locals.tf`). Every fruit becomes a file on disk via the `local_file` resource.

Things to look at:

- `variables.tf`: a typed `map(object({...}))` variable.
- `*.auto.tfvars`: values that are loaded automatically, no `-var-file` needed.
- `main.tf`:
  - `for_each` over a map to create one resource per entry.
  - Filtering with a `for` expression and `if` (only red fruits, or names starting with `ap`).
  - `merge()` of the local and variable map: later arguments win on duplicate keys (`apple`).
- `locals.tf`: `toset()`, `setintersection()` and rebuilding a map from a set of tuples to find
  fruits that are identical in both maps.

Exercises: enable the commented-out resources one by one and predict the plan before you run it.
Change a fruit's color in the tfvars and see which files get replaced.

## Part 2: state

Builds on part 1 and adds a `random_id` and a `local_file` data source. See
[`part_2_state/README.md`](part_2_state/README.md) for the commands used in the workshop.

Topics:

- Inspecting state: `terraform state list`, `terraform state show <address>`.
- Renaming a resource (`local_file.foo` to `local_file.bar`) with `terraform state mv`. A `moved`
  block does the same declaratively.
- Bringing an existing object under management with an `import` block.
- Forgetting a resource without destroying it with a `removed` block and `destroy = false`.
- Reading something Terraform does not manage with a data source (`data.local_file.grape1`, which
  reads the empty `grape1` file in the folder).

`import` and `removed` blocks are preferred over the CLI equivalents when Terraform runs from a
CI/CD pipeline, because they go through the normal plan/apply review.

## Part 4: environments

A website and a docs website on Azure: resource groups, App Service, storage accounts with private
endpoints, Key Vault, PostgreSQL and SQL databases, a CDN and a Datadog synthetics test.

The code is copied into `dev`, `test` and `prod`. The only difference between the folders is
`defaults.auto.tfvars` (environment name, location, database size, monitoring on or off). Use it to
discuss:

- Why copying a root module per environment does not scale, and alternatives (modules, one root
  module with a tfvars file or workspace per environment).
- `validation` blocks, `optional()` object attributes with defaults, `try()`, conditional `count`.
- `lifecycle { prevent_destroy = true }` on databases.
- Secrets: generated passwords stored in Key Vault versus hardcoded ones.

The subscription id, subnet ids and Datadog keys are dummies. This part is meant for reading,
reviewing and refactoring, not for applying. It deliberately contains mistakes and outdated
resources; finding them with `terraform validate` and a review is part of the exercise.

## Part 5: a minimal module

The smallest useful configuration: one variable with a default, one resource and two outputs.
Try overriding the variable:

```sh
terraform apply -var 'greeting=Hi there'
terraform output greeting_content
```

Then write the tests in `tests/local_test.tftest.hcl` and run them:

```sh
terraform test                              # runs tests/ (your work)
terraform test -test-directory=solution     # the reference solution
```

## Cleaning up

Parts 1, 2 and 5 write files (`foo.bar`, one file per fruit, `greeting.txt`) and a local
`terraform.tfstate` into the folder. Run `terraform destroy` when you are done and don't commit
state files or the `.terraform` directory.
