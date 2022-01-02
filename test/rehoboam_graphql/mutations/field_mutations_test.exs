defmodule RehoboamGraphQl.Schema.FieldMutationTest do
  use Rehoboam.DataCase
  alias Rehoboam.Schemas.Field
  alias Rehoboam.Schemas.FieldMock
  alias Rehoboam.Schemas.FieldService

  def prepare_ctx(ctx) do
    %{
      ctx |
        roles: [:admin],
        session: %{
          id: 1,
          user: %{
            id: 1,
            roles: [:admin]
          }
        }
    }
  end

  describe "field delete" do
    setup do
      ctx = %Potionx.Context.Service{
          changes: FieldMock.run(),
        } |> prepare_ctx
      {:ok, entry} = FieldService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry}
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

  describe "field new mutation" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: FieldMock.run() |> Map.delete(:id)
        } |> prepare_ctx
      {:ok, ctx: ctx}
    end

    test "creates field", %{ctx: ctx} do
      changes = Enum.map(ctx.changes, fn
        {k, v} when v === %{} -> {k, Jason.encode!(%{})}
        {k, v} -> {k, v}
      end)
      |> Enum.into(%{})

      Elixir.File.read!("shared/src/models/Schemas/Field/fieldMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        [
          context: ctx,
          variables: %{
            "changes" => Jason.decode!(Jason.encode!(changes))
          }
        ]
      )
      |> (fn {:ok, res} ->
        assert res.data["fieldMutation"]["node"]["id"]
      end).()
    end
  end

  describe "field invalid mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: %{},
        } |> prepare_ctx
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

  describe "field patch mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: FieldMock.run(),
        } |> prepare_ctx
      required_field =
        Field.changeset(%Field{}, %{})
        |> Map.get(:errors)
        |> Keyword.keys
        |> Enum.at(0)
      {:ok, entry} = FieldService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry, required_field: required_field}
    end

    test "patches field", %{ctx: ctx, entry: entry, required_field: required_field} do
      changes =
        required_field && Map.put(%{}, to_string(required_field), FieldMock.run_patch()[required_field]) || %{}

      changes = Enum.map(changes, fn
        {k, v} when v === %{} -> {k, Jason.encode!(%{})}
        {k, v} -> {k, v}
      end)
      |> Enum.into(%{})

      Elixir.File.read!("shared/src/models/Schemas/Field/fieldMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => changes,
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
        assert res.data["fieldMutation"]["node"]["id"]
        if required_field do
          assert res.data["fieldMutation"]["node"][to_string(required_field)] === FieldMock.run_patch()[required_field]
        end
      end).()
    end
  end
end
