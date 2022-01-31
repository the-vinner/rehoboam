defmodule RehoboamGraphQl.Schema.EntryQueryTest do
  use Rehoboam.DataCase
  alias Rehoboam.Entries.EntryMock
  alias Rehoboam.Entries.EntryService

  describe "entry collection and single" do
    setup do
      ctx = %Potionx.Context.Service{
          changes: EntryMock.run(),
          roles: [:admin],
          session: %{
            id: 1,
            user: %{
              id: 1,
              roles: [:admin]
            }
          }
        }
      {:ok, entry} = EntryService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry}
    end
    test "returns collection of entry", %{ctx: ctx} do
      File.read!("shared/src/models/Entries/Entry/entryCollection.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "first" => 15
        }
      )
      |> (fn {:ok, res} ->
        assert res.data["entryCollection"]["count"] === 1
        assert res.data["entryCollection"]["edges"] |> Enum.count === 1
      end).()
    end
    test "returns single entry", %{ctx: ctx, entry: entry} do
      File.read!("shared/src/models/Entries/Entry/entrySingle.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "filters" => %{
            "id" => Absinthe.Relay.Node.to_global_id(
              :entry,
              entry.id,
              RehoboamGraphQl.Schema
            )
          }
        }
      )
      |> (fn {:ok, res} ->
        assert res.data["entrySingle"]["id"] ===
          Absinthe.Relay.Node.to_global_id(
            :entry,
            entry.id,
            RehoboamGraphQl.Schema
          )
      end).()
    end
  end
end
