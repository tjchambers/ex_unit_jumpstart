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

  def modules(path) do
    Code.compile_file(path)
    |> Enum.map(fn {module, _binary} -> module end)
  end
end
