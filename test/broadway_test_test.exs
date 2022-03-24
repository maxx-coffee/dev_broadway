defmodule BroadwayTestTest do
  use ExUnit.Case
  doctest BroadwayTest

  test "greets the world" do
    assert BroadwayTest.hello() == :world
  end
end
