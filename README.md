# ex_unit_jumpstart

# WORK IN PROGRESS - Do Not Use

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
    {:ex_unit_jumpstart, "~> 0.0.3"},
  ]
end
```

## Configure the app

Follow the Phoenix config process for
[deployment](https://hexdocs.pm/phoenix/deployment.html) and
[releases](https://hexdocs.pm/phoenix/releases.html).

### Initialize `ex_unit_jumpstart` and generate files

`ex_unit_jumpstart` generate output files from templates.

Generate output files:

```shell
# Create ExUnit test template files
mix ex_unit_jumpstart.generate
```

I am `Tim Chambers` on on the Elixir Slack, `tjchambers` on
Github. Happy to chat or help with your projects.

## Copyright

Copyright (c) 2023 Timothy Chambers

