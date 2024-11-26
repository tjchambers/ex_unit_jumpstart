defmodule ExUnitJumpstart.GetCodeFiles do
  @moduledoc """
  Get a list of code files and their modules.
  """

  @doc """
  Get a list of code files and their modules.
  """
  @spec get_code_files(Keyword.t()) :: list(ExUnitJumpstart.CodeFile.t())
  def get_code_files(config) do
    paths = Path.wildcard("#{config[:code_dir]}/**/*.ex")

    paths
    |> Enum.map(fn path ->
      %ExUnitJumpstart.CodeFile{
        path: path |> String.replace(config[:code_dir] <> "/", ""),
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
