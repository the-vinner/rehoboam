defmodule RehoboamGraphQl.Schemas.SchemaToSdl do
  use Rehoboam.DataCase

  describe "generates an SDL from schemas" do
    setup do
      ctx =
        prepare_ctx(%Potionx.Context.Service{
          changes: Rehoboam.Schemas.SchemaMock.run()
        })

      {:ok, entry} = Rehoboam.Schemas.SchemaService.mutation(ctx)
      {:ok, ctx: ctx, entry: Enum.at(entry.fields, 0), schema: entry}
    end
    test "generate_sdl/1", %{schema: schema} do
      schema = %{schema | schema_id: schema.id}
      Rehoboam.Schemas.SchemaToSdl.generate_sdl([schema])
      |> RehoboamGraphQl.Schema.rebuild()

      """
      query {
        someHandle {
          id
        }
      }
      """
      |> Absinthe.run(RehoboamGraphQl.Schema)
      |> then(fn res ->
        assert res === {:ok, %{data: %{"someHandle" => %{"id" => "1"}}}}
      end)
    end
  end
end
