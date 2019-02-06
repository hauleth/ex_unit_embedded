defmodule ExUnitEmbeddedTest do
  use ExUnit.Case
  import ExUnitEmbedded
  doctest ExUnitEmbedded

  unittest Example

  test "greets the world" do
    assert true
  end
end
