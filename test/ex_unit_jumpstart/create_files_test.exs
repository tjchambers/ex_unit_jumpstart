defmodule ExUnitJumpstart.CreateFilesTest do
  use ExUnit.Case, async: true

  describe "create_missing_test_files/1" do
    test "creates a test file for each code file" do
      mix_config = Mix.Project.config()
      user_config = []
      cfg = Mix.Tasks.ExUnitJumpstart.create_config(mix_config, user_config)

      # Arrange
      code_files =
        [
          "ex_unit_jumpstart.ex",
          "ex_unit_jumpstart/code_file.ex",
          "ex_unit_jumpstart/move_files.ex",
          "ex_unit_jumpstart/templates.ex",
          "ex_unit_jumpstart/test_file.ex"
        ]
        |> Enum.map(fn path -> %ExUnitJumpstart.CodeFile{path: path, modules: []} end)

      # Act
      ExUnitJumpstart.CreateFiles.create_missing_test_files(cfg, code_files, [])

      # Assert
      assert File.exists?("test/ex_unit_jumpstart/code_file_test.exs")
      assert File.exists?("test/ex_unit_jumpstart/move_files_test.exs")
      assert File.exists?("test/ex_unit_jumpstart/templates_test.exs")
      assert File.exists?("test/ex_unit_jumpstart/test_file_test.exs")
    end
  end
end
