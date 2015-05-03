defmodule CuidTest do
  use ExUnit.Case, async: true
  require Cuid

  setup do
    {:ok, generator} = Cuid.start_link
    {:ok, generator: generator}
  end

  test "generate string", %{generator: generator} do
    assert is_binary Cuid.generate(generator)
  end

  test "format", %{generator: generator} do
    c = Cuid.generate(generator)
    assert String.length(c) == 25
    assert String.starts_with?(c, "c")
  end

  test "collision", %{generator: generator} do
    number_of_iterations = 200_000

    result =
      Stream.repeatedly(fn -> Cuid.generate(generator) end)
      |> Stream.take(number_of_iterations)
      |> Enum.into(HashSet.new)

    assert result.size == number_of_iterations
  end
end
