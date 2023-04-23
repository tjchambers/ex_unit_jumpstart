defmodule ExUnitJumpstart.GetTestFiles do
  def get_test_files(config) do
    Path.wildcard("#{config[:test_dir]}/**/*.exs")
    |> Enum.map(fn path ->
      %ExUnitJumpstart.TestFile{
        path: path |> String.replace(config[:test_dir] <> "/", ""),
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
