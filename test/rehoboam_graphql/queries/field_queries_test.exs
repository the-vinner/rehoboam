defmodule RehoboamGraphQl.Schema.FieldQueryTest do
  use Rehoboam.DataCase

  describe "field collection and single" do
    setup do
      ctx =
        prepare_ctx(%Potionx.Context.Service{
          changes: Rehoboam.Schemas.SchemaMock.run()
        })

      {:ok, entry} = Rehoboam.Schemas.SchemaService.mutation(ctx)
      {:ok, ctx: ctx, entry: Enum.at(entry.fields, 0), schema: entry}
    end
    test "returns collection of field", %{ctx: ctx, schema: schema} do
      File.read!("shared/src/models/Schemas/Field/fieldCollection.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "filters" => %{
            "schemaId" => schema.id
          },
          "first" => 15
        }
      )
      |> (fn {:ok, res} ->
        assert res.data["fieldCollection"]["count"] === 4
        assert res.data["fieldCollection"]["edges"] |> Enum.count === 4
      end).()
    end
    test "returns single field", %{ctx: ctx, entry: entry} do

      """
      type Query {
        "A list of posts"
        posts(reverse: Boolean): [Post]
      }
      type Post {
        id: String
        title: String!
      }
      """
      |> RehoboamGraphQl.Schema.rebuild()

      """
      query posts {
        posts {
          id
        }
      }
      """
      |> Absinthe.run(RehoboamGraphQl.Schema)
      |> IO.inspect(label: "result")

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
