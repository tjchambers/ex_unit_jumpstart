defmodule ExUnitJumpstart.MixProject do
  use Mix.Project

  @github "https://github.com/tjchambers/ex_unit_jumpstart"
  @version "0.0.1"

  def project do
    [
      app: :ex_unit_jumpstart,
      version: @version,
      elixir: "~> 1.14",
      package: package(),
      source_url: @github,
      homepage_url: @github,
      docs: docs(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :eex],
        # plt_add_deps: true,
        # flags: ["-Werror_handling", "-Wrace_conditions"],
        flags: ["-Wunmatched_returns", :error_handling, :race_conditions, :underspecs],
        # ignore_warnings: "dialyzer.ignore-warnings"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
    ]
  end

  defp package do
    [
      description: "Generate ExUnit unit test skeleton modules for an application.",
      maintainers: ["Tim Chambers"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @github,
      source_url_pattern: "#{@github}/blob/master/%{path}#L%{line}",
      formatters: ["html"]
    ]
  end
end
