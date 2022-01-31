defmodule RehoboamGraphQl.Schema.EntryMutationTest do
  use Rehoboam.DataCase
  alias Rehoboam.Entries.Entry
  alias Rehoboam.Entries.EntryMock
  alias Rehoboam.Entries.EntryService

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

  describe "entry delete" do
    setup do
      ctx = %Potionx.Context.Service{
          changes: EntryMock.run(),
        } |> prepare_ctx
      {:ok, entry} = EntryService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry}
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
          changes: EntryMock.run() |> Map.delete(:id)
        } |> prepare_ctx
      {:ok, ctx: ctx}
    end

    test "creates entry", %{ctx: ctx} do
      changes = Enum.map(ctx.changes, fn
        {k, v} when v === %{} -> {k, Jason.encode!(%{})}
        {k, v} -> {k, v}
      end)
      |> Enum.into(%{})

      Elixir.File.read!("shared/src/models/Entries/Entry/entryMutation.gql")
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
        assert res.data["entryMutation"]["node"]["id"]
      end).()
    end
  end

  describe "entry invalid mutation/2" do
    setup do
      ctx =
        %Potionx.Context.Service{
          changes: %{},
        } |> prepare_ctx
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
          changes: EntryMock.run(),
        } |> prepare_ctx
      required_field =
        Entry.changeset(%Entry{}, %{})
        |> Map.get(:errors)
        |> Keyword.keys
        |> Enum.at(0)
      {:ok, entry} = EntryService.mutation(ctx)
      {:ok, ctx: ctx, entry: entry, required_field: required_field}
    end

    test "patches entry", %{ctx: ctx, entry: entry, required_field: required_field} do
      changes =
        required_field && Map.put(%{}, to_string(required_field), EntryMock.run_patch()[required_field]) || %{}

      changes = Enum.map(changes, fn
        {k, v} when v === %{} -> {k, Jason.encode!(%{})}
        {k, v} -> {k, v}
      end)
      |> Enum.into(%{})

      Elixir.File.read!("shared/src/models/Entries/Entry/entryMutation.gql")
      |> Absinthe.run(
        RehoboamGraphQl.Schema,
        context: ctx,
        variables: %{
          "changes" => changes,
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
        assert res.data["entryMutation"]["node"]["id"]
        if required_field do
          assert res.data["entryMutation"]["node"][to_string(required_field)] === EntryMock.run_patch()[required_field]
        end
      end).()
    end
  end
end
