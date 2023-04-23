defmodule ExUnitJumpstart.GetCodeFiles do
  @moduledoc """
  Get a list of code files and their modules.
  """
  def get_code_files(config) do
    Path.wildcard("#{config[:code_dir]}/**/*.ex")
    |> Enum.map(fn path ->
      %ExUnitJumpstart.CodeFile{
        path: path |> String.replace(config[:code_dir] <> "/", ""),
        modules: modules(path)
      }
    end)
  end

  defp modules(path) do
    result = Code.require_file(path)
    result = case result do
      nil ->
        Code.compile_file(path)

        _-> result
    end

    result |> Enum.map(fn {module, _binary} -> module end)
  end
end
