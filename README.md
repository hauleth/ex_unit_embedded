# ExUnitEmbedded

Define tests within module to test private functions.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_unit_embedded` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_unit_embedded, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exunit_embedded](https://hexdocs.pm/ex_unit_embedded).

## Usage

Simply use `ExUnitEmbedded` and define your tests (no `describe` available):

```elixir
defmodule Foo do
  use ExUnitEmbedded

  defp foo, do: :ok

  test "foo/0 returns :ok" do
    assert :ok = foo()
  end
end
```

Then in your test module invoke `unittest Foo`:

```elixir
defmodule FooTest do
  use ExUnit.Case
  import ExUnitEmbedded

  unittest Foo
end
```

## License

Apache 2.0, see [LICENSE](LICENSE).
