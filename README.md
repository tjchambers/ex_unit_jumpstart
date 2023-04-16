# ex_unit_jumpstart

This module generates ExUnit style unit test skeletons for an Elixir Project.

- Generates test files with appropriate jumpstart headers for each module.
- Ensures that those test modules are in the orthogonal folder relative to the original code module folder structure
- Adds Unit test skeletons for each module function/arity
- Updates existing ExUnit test files as new functions are added/modified in the original code


## Installation

Add `ex_unit_jumpstart` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_unit_jumpstart, "~> 0.0.1"},
  ]
end
```

## Configure the app

Follow the Phoenix config process for
[deployment](https://hexdocs.pm/phoenix/deployment.html) and
[releases](https://hexdocs.pm/phoenix/releases.html).

### Initialize `ex_unit_jumpstart` and generate files

`ex_unit_jumpstart` generate output files from templates.
Run the following to copy the templates into your project. The templating
process most common needs via configuration, but you can also check them into
your project and make local modifications to handle special needs.

```shell
mix ex_unit_jumpstart.init
```

Generate output files:

```shell
# Create ExUnit test template files
mix ex_unit_jumpstart.generate
```

I am `Tim Chambers` on on the Elixir Slack, `tjchambers` on
Github. Happy to chat or help with your projects.

## Copyright and License

Copyright (c) 2023 Timothy Chambers

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
