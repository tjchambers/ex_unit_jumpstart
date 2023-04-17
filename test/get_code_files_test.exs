defmodule ExUnitJumpstart.GetCodeFilesTest do
  use ExUnit.Case

  test "get_code_files/1" do
    mix_config = Mix.Project.config()
    user_config = []
    cfg = Mix.Tasks.ExUnitJumpstart.create_config(mix_config, user_config)

    code_files = ExUnitJumpstart.GetCodeFiles.get_code_files(cfg)

    last = code_files |> List.last()

    assert length(code_files) == 9
    assert last.path == "mix/tasks/ex_unit_jumpstart.ex"
    assert length(last.modules) == 3
    assert last.modules |> List.last() == Mix.Tasks.ExUnitJumpstart.Generate
  end
end
