defmodule RehoboamGraphQl.Schema.FieldQueryTest do
  use Rehoboam.DataCase
  alias Rehoboam.Schemas.FieldMock
  alias Rehoboam.Schemas.FieldService

  describe "field collection and single" do
    setup do
      ctx = %Potionx.Context.Service{
          changes: FieldMock.run(),
          roles: [:admin],
          session: %{
            id: 1,
            user: %{
              id: 1,
              roles: [:admin]
            }
          }
        }
      {:ok, entry} = FieldService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry}
    end
    test "returns collection of field", %{ctx: ctx} do
      File.read!("shared/src/models/Schemas/Field/fieldCollection.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "first" => 15
        }
      )
      |> (fn {:ok, res} ->
        assert res.data["fieldCollection"]["count"] === 1
        assert res.data["fieldCollection"]["edges"] |> Enum.count === 1
      end).()
    end
    test "returns single field", %{ctx: ctx, entry: entry} do
      File.read!("shared/src/models/Schemas/Field/fieldSingle.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "filters" => %{
            "id" => Absinthe.Relay.Node.to_global_id(
              :field,
              entry.id,
              RehoboamGraphQl.Schema
            )
          }
        }
      )
      |> (fn {:ok, res} ->
        assert res.data["fieldSingle"]["id"] ===
          Absinthe.Relay.Node.to_global_id(
            :field,
            entry.id,
            RehoboamGraphQl.Schema
          )
      end).()
    end
  end
end
