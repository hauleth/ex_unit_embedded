defmodule Example do
  import ExUnitEmbedded

  defp foo, do: nil

  unit_tests do
    test "foo/0 returns nil" do
      assert nil == foo()
    end
  end
end
