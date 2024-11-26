defmodule Mix.Tasks.ExUnitJumpstart do
  @moduledoc false

  @app :ex_unit_jumpstart

  @defaults [
    test_dir: "test",
    code_dir: "lib",
    template_dir: "priv/templates",
    dry_run: false
  ]

  @doc "Generate cfg from mix.exs and app config"
  @spec parse_args(OptionParser.argv()) :: Keyword.t()
  def parse_args(argv) do
    opts = [strict: [version: :string, test_dir: :string, code_dir: :string, template_dir: :string, dry_run: :boolean]]
    {overrides, _} = OptionParser.parse!(argv, opts)

    user_config = Keyword.merge(Application.get_all_env(@app), overrides)
    mix_config = Mix.Project.config()

    create_config(mix_config, user_config)
  end

  @doc "Generate cfg based on params"
  @spec create_config(Keyword.t(), Keyword.t()) :: Keyword.t()
  def create_config(_mix_config, user_config) do
    # Override values from user config
    cfg = Keyword.merge(@defaults, user_config)

    # Calculate values from other things

    Keyword.merge(
      [
        test_dir: cfg[:test_dir],
        code_dir: cfg[:code_dir]
      ],
      cfg
    )
  end

  # Expand cfg vars in keys
  @doc false
  @spec expand_keys(Keyword.t(), list(atom)) :: Keyword.t()
  def expand_keys(cfg, keys) do
    Enum.reduce(Keyword.take(cfg, keys), cfg, fn {key, value}, acc ->
      Keyword.put(acc, key, expand_value(value, acc))
    end)
  end

  # Expand vars in value or list of values
  @doc false
  @spec expand_value(atom | binary | list, Keyword.t()) :: binary | list(binary)
  def expand_value(values, cfg) when is_list(values) do
    Enum.map(values, &expand_vars(&1, cfg))
  end

  def expand_value(value, cfg), do: expand_vars(value, cfg)

  # Expand references in values
  @doc false
  @spec expand_vars(binary | nil | atom | list, Keyword.t()) :: binary
  def expand_vars(value, _cfg) when is_binary(value), do: value
  def expand_vars(nil, _cfg), do: ""

  def expand_vars(key, cfg) when is_atom(key) do
    case Keyword.fetch(cfg, key) do
      {:ok, value} ->
        expand_vars(value, cfg)

      :error ->
        to_string(key)
    end
  end

  def expand_vars(terms, cfg) when is_list(terms) do
    terms
    |> Enum.map(&expand_vars(&1, cfg))
    |> Enum.join("")
  end

  def expand_vars(value, _cfg), do: to_string(value)
end
