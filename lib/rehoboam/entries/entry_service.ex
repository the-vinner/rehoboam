defmodule Rehoboam.Entries.EntryService do
  alias Potionx.Context.Service
  alias Rehoboam.Entries.Entry
  alias Rehoboam.Repo
  import Ecto.Query

  def count(%Service{} = ctx) do
    from(item in query(ctx))
    |> select([i], count(i.id))
    |> exclude(:order_by)
    |> Repo.one!
  end

  def delete(%Service{} = ctx) do
    query(ctx)
    |> Repo.one
    |> case do
      nil -> {:error, "not_found"}
      entry ->
        entry
        |> Repo.delete
    end
  end

  def mutation(%Service{filters: %{id: id}} = ctx) when not is_nil(id) do
    query(ctx)
    |> Repo.one
    |> case do
      nil -> {:error, "not_found"}
      entry ->
        Entry.changeset(entry, ctx.changes)
        |> Repo.update
    end
  end
  def mutation(%Service{} = ctx) do
    %Entry{}
    |> Entry.changeset(ctx.changes)
    |> Repo.insert
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one
  end

  def query(%Service{} = ctx) do
    Entry
    |> search(ctx)
    |> where(
      ^(
        ctx.filters
        |> Map.to_list
      )
    )
    |> order_by([desc: :id])
  end
  def query(q, _args), do: q

  @doc """
  A search function that searches all string columns by default.
  """
  def search(query, %Service{search: nil}), do: query
  def search(query, %Service{search: ""}), do: query
  def search(query, %Service{search: s}) do
    clauses =
      Entry.__schema__(:fields)
      |> Enum.reduce(nil, fn field_name, query ->
        if (Entry.__schema__(:type, field_name) === :string) do
          if (query === nil) do
            dynamic([p], ilike(field(p, ^field_name), ^"%#{s}%"))
          else
            dynamic([p], ilike(field(p, ^field_name), ^"%#{s}%") or ^query)
          end
        else
          query
        end
      end)
    from(query, where: ^clauses)
  end
end
