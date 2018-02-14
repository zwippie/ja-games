defmodule Klikker.RobotPuzzel.GeneratorTest do
  use ExUnit.Case, async: true

  test "it generates a new puzzle" do
    assert puzzle = Klikker.RobotPuzzel.Generator.generate()
    assert is_list(puzzle)
    assert %{color: _, index: _} = hd(puzzle)
  end
end
