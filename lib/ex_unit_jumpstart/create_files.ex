defmodule ExUnitJumpstart.CreateFiles do
  @moduledoc """
  Creates test files for code files that don't have a test file.
  """

  def create_missing_test_files(config, code_files, test_files) do
    code_files
    |> Enum.map(fn code_file ->
      test_file =
        test_files
        |> Enum.find(fn test_file ->
          String.replace(test_file.path, "_test.exs", ".ex") == code_file.path
        end)

      unless is_nil(test_file) or Keyword.fetch!(config,:dry_run) do
        IO.puts("Creating test file for #{code_file.path}")
        create_test_file(config, code_file)
      end
    end)
  end

  def create_test_file(config, code_file) do
    test_file = gen_test_file_skeleton(config, code_file)

    File.mkdir_p!(Path.dirname(test_file.path))
    File.write!(test_file.path, test_file.content)
  end

  def gen_test_file_skeleton(config, code_file) do
    %{
      path: Path.join(config[:test_dir], code_file.path) |> String.replace(".ex", "_test.exs"),
      content: content(code_file)
    }
  end

  def content(code_file) do
    code_file.modules
    |> Enum.map(fn module ->
      """
      defmodule #{module}Test do
        use ExUnit.Case, async: true

      end

      """
    end)
    |> Enum.join("\n")
  end
end
