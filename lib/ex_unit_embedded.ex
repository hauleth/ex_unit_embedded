#  Copyright 2018 Łukasz Niemier
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

defmodule ExUnitEmbedded do
  @moduledoc """
  Documentation for ExUnitEmbedded.
  """

  defmodule Macros do
    defmacro test(message, var \\ quote(do: _), contents) do
      contents =
        case contents do
          [do: block] ->
            quote do
              import ExUnit.Assertions

              unquote(block)
              :ok
            end

          _ ->
            quote do
              import ExUnit.Assertions

              try(unquote(contents))
              :ok
            end
        end

      var = Macro.escape(var)
      contents = Macro.escape(contents, unquote: true)

      quote bind_quoted: [var: var, contents: contents, message: message] do
        if @ex_unit_embedded_enabled do
          name = :"embedded #{message}"
          def unquote(name)(unquote(var)), do: unquote(contents)

          @ex_unit_embedded_tests {message, name}
        end
      end
    end
  end

  defmacro __using__(opts) do
    envs =
      opts
      |> Keyword.get(:envs, [:test])
      |> List.wrap()

    quote do
      import unquote(Macros), only: [test: 2]

      @ex_unit_embedded_enabled Mix.env() in unquote(envs)

      if @ex_unit_embedded_enabled do
        Module.register_attribute(__MODULE__, :ex_unit_embedded_tests,
          accumulate: true,
          persist: true
        )
      end
    end
  end

  defmacro unittest(mod) do
    quote bind_quoted: [mod: mod] do
      tests = Keyword.get(mod.module_info(:attributes), :ex_unit_embedded_tests, [])

      for {message, function} <- tests do
        name = ExUnit.Case.register_test(__ENV__, :embedded, message, [])
        def unquote(name)(env), do: apply(unquote(mod), unquote(function), [env])
      end
    end
  end
end
