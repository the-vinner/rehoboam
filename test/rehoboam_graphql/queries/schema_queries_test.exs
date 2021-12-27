defmodule RehoboamGraphQl.Schema.SchemaQueryTest do
  use Rehoboam.DataCase
  alias Rehoboam.Schemas.SchemaMock
  alias Rehoboam.Schemas.SchemaService

  describe "schema collection and single" do
    setup do
      ctx =
        prepare_ctx(%Potionx.Context.Service{
          changes: SchemaMock.run()
        })

      {:ok, entry} = SchemaService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry}
    end

    test "returns collection of schema", %{ctx: ctx} do
      File.read!("shared/src/models/Schemas/Schema/schemaCollection.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "first" => 15
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["schemaCollection"]["count"] === 1
            assert res.data["schemaCollection"]["edges"] |> Enum.count() === 1
          end).()
    end

    test "returns single schema", %{ctx: ctx, entry: entry} do
      File.read!("shared/src/models/Schemas/Schema/schemaSingle.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "filters" => %{
            "id" =>
              Absinthe.Relay.Node.to_global_id(
                :schema,
                entry.id,
                RehoboamGraphQl.Schema
              )
          }
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["schemaSingle"]["id"] ===
                     Absinthe.Relay.Node.to_global_id(
                       :schema,
                       entry.id,
                       RehoboamGraphQl.Schema
                     )
          end).()
    end
  end
end
