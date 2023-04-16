defmodule Mix.Tasks.ExUnitJumpstart do
  @moduledoc false

  # Directory where `mix ex_unit_jumpstart.generate` stores output files,
  @output_dir "test"

  # Directory where `mix ex_unit_jumpstart.init` copies templates in user project
  @template_dir "rel/templates/ExUnitJumpstart"

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
    # Elixir app name, from mix.exs
    app_name = mix_config[:app]

    # Name of systemd unit
    service_name = ext_name

    # Elixir camel case module name version of snake case app name
    module_name =
      app_name
      |> to_string
      |> String.split("_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join("")

    build_path = Mix.Project.build_path()

    defaults = [
      # Elixir application name
      app_name: app_name,

      # Elixir module name in camel case
      module_name: module_name,

      # Config keys which have variable expansion
      expand_keys: [],

      # Add your keys here
      expand_keys_extra: []
    ]

    # Override values from user config
    cfg = Keyword.merge(defaults, user_config)

    # Calculate values from other things
    cfg =
      Keyword.merge(
        [
          releases_dir: cfg[:releases_dir] || Path.join(cfg[:ExUnitJumpstart_dir], "releases")
        ],
        cfg
      )

    # for {key, value} <- cfg do
    #   Mix.shell.info "cfg: #{key} #{inspect value}"
    # end

    expand_keys(cfg, cfg[:expand_keys] ++ cfg[:expand_keys_extra])
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

    * `--template_dir` - target directory

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
  Create ExUnitJumpstart scripts and files for project.

  ## Usage

      # Create scripts and files
      mix ex_unit_jumpstart.generate
  """
  @shortdoc "Create ExUnitJumpstart scripts and files"
  use Mix.Task

  alias MixExUnitJumpstart.Templates

  @impl Mix.Task
  def run(args) do
    cfg = Mix.Tasks.ExUnitJumpstart.parse_args(args)

    files =
      cfg[:copy_files] ++
        []

    files =
      for file <- files, file[:enabled] != false do
        %{
          file
          | src: Mix.Tasks.ExUnitJumpstart.expand_vars(file.src, cfg),
            dst: Mix.Tasks.ExUnitJumpstart.expand_vars(file.dst, cfg)
        }
      end

    dirs =
      for dir <- dirs, dir[:enabled] != false do
        %{dir | path: Mix.Tasks.ExUnitJumpstart.expand_vars(dir.path, cfg)}
      end

    vars = Keyword.merge(cfg, create_dirs: dirs, copy_files: files)

    for template <- cfg[:templates], do: write_template(vars, cfg[:bin_dir], template)

    if cfg[:sudo_ExUnitJumpstart] or cfg[:sudo_app] do
      # Give ExUnitJumpstart and/or app user ability to run start/stop commands via sudo
      write_template(
        cfg,
        Path.join(cfg[:output_dir], "/etc/sudoers.d"),
        "sudoers",
        cfg[:ext_name]
      )
    end
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
