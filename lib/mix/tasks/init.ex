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

    IO.puts("Copying templates to #{template_dir}")
    :ok = File.mkdir_p(template_dir)
    {:ok, _files} = File.cp_r(app_dir, template_dir)
  end
end
