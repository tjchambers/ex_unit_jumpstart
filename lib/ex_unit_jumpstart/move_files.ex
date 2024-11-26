defmodule ExUnitJumpstart.MoveFiles do
  @moduledoc """
  Move incorrectly located test files to the appropriate test directory.
  """

  @doc """
  Move test files that are not in the correct location to the appropriate test directory.
  """
  @spec move_misplaced_test_files(
          Keyword.t(),
          list(ExUnitJumpstart.CodeFile.t()),
          list(ExUnitJumpstart.TestFile.t())
        ) :: list()
  def move_misplaced_test_files(config, code_files, test_files) do
    test_files
    |> Enum.filter(fn test_file -> test_file_is_misplaced?(test_file, code_files) end)
    |> Enum.map(fn test_file -> move_test_file(code_files, test_file, config) end)
  end

  defp test_file_is_misplaced?(test_file, code_files) do
    path_to_test = String.replace(test_file.path, "_test.exs", ".ex")

    code_files
    |> Enum.find(fn code_file -> code_file.path == path_to_test end)
    |> is_nil()
  end

  defp move_test_file(code_files, test_file, config) do
    IO.puts("Moving #{test_file.path}")

    code_file =
      code_files
      |> Enum.find(fn code_file ->
        code_file.modules ==
          test_file.modules
          |> Enum.map(fn module -> String.trim_trailing(module, "Test") end)
      end)

    if code_file do
      new_path =
        Path.join(config[:test_dir], code_file.path) |> String.replace(".ex", "_test.exs")

      IO.puts("Moving #{test_file.path} to #{new_path}")

      unless config.fetch!(:dry_run) do
        File.mkdir_p!(Path.dirname(new_path))
        File.rename!(Path.join(config[:test_dir], test_file.path), new_path)
      end
    end
  end
end
