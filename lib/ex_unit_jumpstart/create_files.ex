defmodule ExUnitJumpstart.CreateFiles do
  def create_files(config, code_files, test_files) do
    code_files
    |> Enum.map(fn code_file ->
      test_file = test_files |> Enum.find(fn test_file -> test_file.hash == code_file.hash end)

      if test_file do
        IO.puts("Test file already exists for #{code_file}")
      else
        create_test_file(config, code_file)
      end
    end)
  end

  def create_test_file(config, code_file) do
    test_file = gen_test_file_skeleton(config, code_file)

    File.write!(test_file.path, test_file.content)
  end

  def gen_test_file_skeleton(config, code_file) do
    test_file = %{
      path: Path.join(config[:test_dir], code_file.path),
      content: content(code_file)
    }

    test_file
  end

  def content(code_file) do
    """
    defmodule #{code_file.module}Test do
      use ExUnit.Case, async: true

      
    end
    """
  end
end
