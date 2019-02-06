defmodule ExUnitEmbeddedTest do
  use ExUnit.Case
  doctest ExUnitEmbedded

  Example.ex_unit_register()

  test "greets the world" do
    assert true
  end
end
