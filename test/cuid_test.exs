defmodule CuidTest do
  use ExUnit.Case
  require Cuid

  test "generate string" do
    assert is_binary Cuid.new
  end

  test "format" do
    c = Cuid.new
    assert String.length(c) == 25
    assert String.starts_with?(c, "c")
  end

  test "collision" do
    number_of_iterations = 50_000

    result =
      Stream.repeatedly(&Cuid.new/0)
      |> Stream.take(number_of_iterations)
      |> Enum.into(HashSet.new)

    assert result.size == number_of_iterations
  end
end
