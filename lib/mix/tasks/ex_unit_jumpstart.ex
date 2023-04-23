defmodule Mix.Tasks.ExUnitJumpstart do
  @moduledoc false

  @app :ex_unit_jumpstart

  @doc "Generate cfg from mix.exs and app config"
  @spec parse_args(OptionParser.argv()) :: Keyword.t()
  def parse_args(argv) do
    opts = [strict: [version: :string]]
    {overrides, _} = OptionParser.parse!(argv, opts)

    user_config = Keyword.merge(Application.get_all_env(@app), overrides)
    mix_config = Mix.Project.config()

    create_config(mix_config, user_config)
  end

  @doc "Generate cfg based on params"
  @spec create_config(Keyword.t(), Keyword.t()) :: Keyword.t()
  def create_config(mix_config, user_config) do
    defaults = [
      test_dir: "test",
      code_dir: "lib"
    ]

    # Override values from user config
    cfg = Keyword.merge(defaults, user_config)

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

defmodule Mix.Tasks.ExUnitJumpstart.Init do
  @moduledoc """
  Initialize template files.

  ## Command line options

    * `--test_dir` - target directory

  ## Usage

      # Copy default templates into your project
      mix ex_unit_jumpstart.init
  """
  @shortdoc "Initialize template files"
  use Mix.Task

  @app :ex_unit_jumpstart

  @impl Mix.Task
  def run(args) do
    cfg = Mix.Tasks.ExUnitJumpstart.parse_args(args)

    template_dir = cfg[:template_dir]
    app_dir = Application.app_dir(@app, ["priv", "templates"])

    :ok = File.mkdir_p(template_dir)
    {:ok, _files} = File.cp_r(app_dir, template_dir)
  end
end

defmodule Mix.Tasks.ExUnitJumpstart.Generate do
  @moduledoc """
  Create ExUnitJumpstart test files and update existing ones.

  ## Usage

      mix ex_unit_jumpstart.generate
  """
  @shortdoc "Create ExUnitJumpstart scripts and files"
  use Mix.Task

  alias MixExUnitJumpstart.Templates

  @impl Mix.Task
  def run(args) do
    cfg = Mix.Tasks.ExUnitJumpstart.parse_args(args)

    code_files = ExUnitJumpstart.GetCodeFiles.get_code_files(cfg)
    test_files = ExUnitJumpstart.GetTestFiles.get_test_files(cfg)

    ExUnitJumpstart.MoveFiles.move_misplaced_test_files(cfg, code_files, test_files)
    ExUnitJumpstart.CreateFiles.create_missing_test_files(cfg, code_files, test_files)

    # refetch test files after moving and creating
    test_files = ExUnitJumpstart.GetTestFiles.get_test_files(cfg)

    ExUnitJumpstart.UnitTestGenerator.create_unit_tests(cfg, code_files, test_files)
  end

  defp write_template(cfg, dest_dir, template),
    do: write_template(cfg, dest_dir, template, template)

  defp write_template(cfg, dest_dir, template, file) do
    output_file = cfg[:target_prefix] <> file
    # target_file = Path.join(dest_dir, output_file)
    # Mix.shell.info "Generating #{target_file} from template #{template}"
    Templates.write_template(cfg, dest_dir, template, output_file)
  end
end
