defmodule ExUnitJumpstart.MoveFiles do
  @moduledoc """
  Move incorrectly located test files to the appropriate test directory.
  """
  def move_misplaced_test_files(config, code_files, test_files) do
    test_files
    |> Enum.filter(fn test_file -> test_file_is_misplaced?(test_file, code_files) end)
    |> Enum.map(fn test_file -> move_test_file(code_files, test_file, config) end)
  end

  def test_file_is_misplaced?(test_file, code_files) do
    code_files
    |> Enum.find(fn code_file -> code_file.path == test_file.path end)
    |> is_nil
  end

  def move_test_file(code_files, test_file, config) do
    code_file =
      code_files
      |> Enum.find(fn code_file ->
        code_file.modules ==
          test_file.modules
          |> Enum.map(fn module -> Atom.to_string(module)[.. - 4] |> String.to_atom() end)
      end)

    if code_file do
      new_path = Path.join(config[:test_dir], code_file.path)

      File.mkdir_p!(Path.dirname(new_path))
      File.rename!(test_file.path, new_path)
    end
  end
end
