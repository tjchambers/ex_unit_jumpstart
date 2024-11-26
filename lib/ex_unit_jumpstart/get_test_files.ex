defmodule ExUnitJumpstart.GetTestFiles do
  @moduledoc """
  Get a list of test files and their modules.
  """

  @doc """
  Get a list of test files and their modules.
  """
  @spec get_test_files(Keyword.t()) :: list(ExUnitJumpstart.TestFile.t())
  def get_test_files(config) do
    paths = Path.wildcard("#{config[:test_dir]}/**/*.exs")

    paths
    |> Enum.map(fn path ->
      %ExUnitJumpstart.TestFile{
        path: path |> String.replace(config[:test_dir] <> "/", ""),
        modules: modules(path)
      }
    end)
  end

  defp modules(path) do
    content = File.read!(path)

    Regex.scan(~r/defmodule (.*?) do/, content)
    |> Enum.flat_map(fn [_, y] -> [y] end)
  end
end
