defmodule Example do
  use ExUnitEmbedded

  defp foo, do: nil

  test "foo/0 returns nil" do
    assert nil == foo()
  end
end
