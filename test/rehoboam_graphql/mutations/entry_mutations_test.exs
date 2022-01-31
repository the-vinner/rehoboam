defmodule RehoboamGraphQl.Schema.EntryMutationTest do
  use Rehoboam.DataCase
  alias Rehoboam.Entries.EntryMock

  describe "entry delete" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: %{}
        }
        |> prepare_ctx

      {:ok, ctx: ctx, entry: create_entry(ctx.user)}
    end

    test "deletes entry", %{ctx: ctx, entry: entry} do
      Elixir.File.read!("shared/src/models/Entries/Entry/entryDelete.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{"filters" => %{"id" => entry.id}}
      )
      |> (fn {:ok, res} ->
            assert res.data["entryDelete"]["node"]["id"] ===
                     Absinthe.Relay.Node.to_global_id(
                       :entry,
                       entry.id,
                       RehoboamGraphQl.Schema
                     )
          end).()
    end
  end

  describe "entry new mutation" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: EntryMock.run()
        }
        |> prepare_ctx

      schema = create_schema(ctx.user)
      {:ok, ctx: %{ctx | changes: Map.merge(ctx.changes, %{schema_id: schema.id})}}
    end

    test "creates entry", %{ctx: ctx} do
      changes =
        Enum.map(ctx.changes, fn
          {k, v} when v === %{} -> {k, Jason.encode!(%{})}
          {k, v} -> {k, v}
        end)
        |> Enum.into(%{})

      Elixir.File.read!("shared/src/models/Entries/Entry/entryMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => Jason.decode!(Jason.encode!(changes))
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["entryMutation"]["node"]["id"]
          end).()
    end
  end

  describe "entry invalid mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: %{}
        }
        |> prepare_ctx

      {:ok, ctx: ctx}
    end

    test "invalid entry mutation", %{ctx: ctx} do
      Elixir.File.read!("shared/src/models/Entries/Entry/entryMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => Jason.decode!(Jason.encode!(ctx.changes))
        }
      )
      |> (fn {:ok, res} ->
            assert res.data["entryMutation"]["errorsFields"] |> Enum.at(0) |> Map.get("field")
            assert res.data["entryMutation"]["errorsFields"] |> Enum.at(0) |> Map.get("message")
          end).()
    end
  end

  describe "entry patch mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: EntryMock.run()
        }
        |> prepare_ctx

      {:ok, ctx: ctx, entry: create_entry(ctx.user)}
    end

    test "patches entry", %{ctx: ctx, entry: entry} do
      Elixir.File.read!("shared/src/models/Entries/Entry/entryMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => %{
          "dataI18n" => Jason.encode!(%{
              "a" => 2
            })
          },
          "filters" => %{
            "id" =>
              Absinthe.Relay.Node.to_global_id(
                :entry,
                entry.id,
                RehoboamGraphQl.Schema
              )
          }
        }
      )
      |> then(fn {:ok, res} ->
        assert res.data["entryMutation"]["node"]["id"]
        assert res.data["entryMutation"]["node"]["dataI18n"] === %{"a" => 2}
      end)
    end
  end
end
