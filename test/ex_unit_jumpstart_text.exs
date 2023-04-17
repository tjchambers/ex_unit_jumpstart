defmodule ExUnitJumpstartTest do
  use ExUnit.Case

  test "create_config/2" do
    mix_config = Mix.Project.config()
    user_config = []

    cfg = Mix.Tasks.Deploy.create_config(mix_config, user_config)

    assert cfg[:test_dir] == "test"
    assert cfg[:code_dir] == "lib"
  end
end
