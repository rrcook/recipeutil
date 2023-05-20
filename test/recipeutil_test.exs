defmodule RecipeutilTest do
  use ExUnit.Case
  doctest Recipeutil

  test "greets the world" do
    assert Recipeutil.hello() == :world
  end
end
