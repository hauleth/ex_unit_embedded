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

  defmacro unit_tests(opts \\ [], do: block) do
    envs =
      opts
      |> Keyword.get(:envs, [:test])
      |> List.wrap()

    if Mix.env() in envs do
      quote location: :keep do
        moduletag_check = Module.get_attribute(__MODULE__, :moduletag)
        tag_check = Module.get_attribute(__MODULE__, :tag)

        if moduletag_check || tag_check do
          raise "you must set @tag and @moduletag after the call to \"use ExUnit.Case\""
        end

        attributes = [
          :ex_unit_tests,
          :tag,
          :describetag,
          :moduletag,
          :ex_unit_registered,
          :ex_unit_used_describes
        ]

        Enum.each(attributes, &Module.register_attribute(__MODULE__, &1, accumulate: true))

        @before_compile ExUnit.Case
        @ex_unit_describe nil
        use ExUnit.Callbacks

        import ExUnit.Callbacks
        import ExUnit.Assertions
        import ExUnit.Case, only: [describe: 2, test: 1, test: 2, test: 3]
        import ExUnit.DocTest

        unquote(block)

        def ex_unit_register(opts \\ []) do
          async = Keyword.get(opts, :async, false)

          if async do
            ExUnit.Server.add_async_module(__MODULE__)
          else
            ExUnit.Server.add_sync_module(__MODULE__)
          end
        end
      end
    else
      nil
    end
  end
end
