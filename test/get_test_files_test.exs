defmodule ExUnitJumpstart.GetTestFilesTest do
  use ExUnit.Case

  test "get_test_files/1" do
    mix_config = Mix.Project.config()
    user_config = []
    cfg = Mix.Tasks.ExUnitJumpstart.create_config(mix_config, user_config)

    test_files = ExUnitJumpstart.GetTestFiles.get_test_files(cfg)

    last = test_files |> List.last()

    assert length(test_files) > 3
    assert last.path == "test_helper.exs"
    assert length(last.modules) == 0
    assert last.modules |> List.last() == nil
  end
end
