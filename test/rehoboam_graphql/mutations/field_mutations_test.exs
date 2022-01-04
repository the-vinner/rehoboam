defmodule RehoboamGraphQl.Schema.FieldMutationTest do
  use Rehoboam.DataCase
  alias Rehoboam.Schemas.Field

  describe "field delete" do
    setup do
      ctx =
        prepare_ctx(%Potionx.Context.Service{
          changes: Rehoboam.Schemas.SchemaMock.run()
        })

      {:ok, entry} = Rehoboam.Schemas.SchemaService.mutation(ctx)
      {:ok, ctx: ctx, entry: Enum.at(entry.fields, 0), schema: entry}
    end

    test "deletes field", %{ctx: ctx, entry: entry} do
      Elixir.File.read!("shared/src/models/Schemas/Field/fieldDelete.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{"filters" => %{"id" => entry.id}}
      )
      |> (fn {:ok, res} ->
            assert res.data["fieldDelete"]["node"]["id"] ===
                     Absinthe.Relay.Node.to_global_id(
                       :field,
                       entry.id,
                       RehoboamGraphQl.Schema
                     )
          end).()
    end
  end

  describe "field mutation" do
    setup do
      ctx =
        prepare_ctx(%Potionx.Context.Service{
          changes: Rehoboam.Schemas.SchemaMock.run()
        })

      {:ok, entry} = Rehoboam.Schemas.SchemaService.mutation(ctx)
      {:ok, ctx: ctx, schema: entry}
    end

    test "creates field", %{ctx: ctx, schema: schema} do
      Elixir.File.read!("shared/src/models/Schemas/Field/fieldMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => %{
            "handle" => "test",
            "ordering" => 0,
            "schemaId" => schema.id,
            "type" => "TEXT"
          }
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["fieldMutation"]["node"]["id"]
            assert Repo.get(Field, Enum.at(schema.fields, 0).id).ordering === 1
          end).()
    end

    test "reorders field", %{ctx: ctx, schema: schema} do
      Elixir.File.read!("shared/src/models/Schemas/Field/fieldMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => %{
            "ordering" => 3
          },
          "filters" => %{
            "id" => Enum.at(schema.fields, 0).id
          }
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["fieldMutation"]["node"]["id"]
            assert Repo.get(Field, Enum.at(schema.fields, 1).id).ordering === 0
          end).()
    end
  end

  describe "field invalid mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: %{}
        }
        |> prepare_ctx

      {:ok, ctx: ctx}
    end

    test "invalid field mutation", %{ctx: ctx} do
      Elixir.File.read!("shared/src/models/Schemas/Field/fieldMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => Jason.decode!(Jason.encode!(ctx.changes))
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["fieldMutation"]["errorsFields"] |> Enum.at(0) |> Map.get("field")
            assert res.data["fieldMutation"]["errorsFields"] |> Enum.at(0) |> Map.get("message")
          end).()
    end
  end
end
