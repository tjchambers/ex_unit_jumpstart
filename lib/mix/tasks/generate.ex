defmodule Mix.Tasks.ExUnitJumpstart.Generate do
  @moduledoc """
  Create ExUnitJumpstart test files and update existing ones.

  ## Usage

      mix ex_unit_jumpstart.generate
  """
  @shortdoc "Create ExUnitJumpstart scripts and files"
  use Mix.Task

  # alias MixExUnitJumpstart.Templates

  @impl Mix.Task
  def run(args) do
    cfg = Mix.Tasks.ExUnitJumpstart.parse_args(args)

    IO.inspect(cfg)

    code_files = ExUnitJumpstart.GetCodeFiles.get_code_files(cfg)
    test_files = ExUnitJumpstart.GetTestFiles.get_test_files(cfg)

    ExUnitJumpstart.MoveFiles.move_misplaced_test_files(cfg, code_files, test_files)
    # ExUnitJumpstart.CreateFiles.create_missing_test_files(cfg, code_files, test_files)

    # refetch test files after moving and creating
    _test_files = ExUnitJumpstart.GetTestFiles.get_test_files(cfg)

    # ExUnitJumpstart.UnitTestGenerator.create_unit_tests(cfg, code_files, test_files)
  end

  # defp write_template(cfg, dest_dir, template),
  #   do: write_template(cfg, dest_dir, template, template)

  # defp write_template(cfg, dest_dir, template, file) do
  #   output_file = cfg[:target_prefix] <> file
  #   # target_file = Path.join(dest_dir, output_file)
  #   # Mix.shell.info "Generating #{target_file} from template #{template}"
  #   Templates.write_template(cfg, dest_dir, template, output_file)
  # end
end
