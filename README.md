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

Simply import `ExUnitEmbedded` and define your tests within `unit_tests`:

```elixir
defmodule Foo do
  import ExUnitEmbedded

  defp foo, do: :ok

  unit_tests do
    test "foo/0 returns :ok" do
      assert :ok = foo()
    end
  end
end
```

Then in your test module invoke `Foo.ex_unit_register/0`:

```
defmodule FooTest do
  use ExUnit.Case

  Foo.ex_unit_register()
end
```
