defmodule ElixirwithpythonTest do
  use ExUnit.Case
  doctest Elixirwithpython

  test "greets the world" do
    assert Elixirwithpython.hello() == :world
  end
end
