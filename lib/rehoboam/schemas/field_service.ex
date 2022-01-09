defmodule Rehoboam.Schemas.FieldService do
  alias Potionx.Context.Service
  alias Rehoboam.Schemas.Field
  alias Rehoboam.Repo
  import Ecto.Query
  alias Ecto.Multi

  def count(%Service{} = ctx) do
    from(item in query(ctx))
    |> select([i], count(i.id))
    |> exclude(:order_by)
    |> Repo.one!
  end

  def delete(%Service{} = ctx) do
    Multi.new
    |> Multi.run(:field, fn _, _ ->
      query(ctx)
      |> Repo.one
      |> case do
        nil -> {:error, "not_found"}
        entry ->
          entry
          |> Repo.delete
      end
    end)
    |> Multi.run(:fields_ordering, fn repo, %{field: field} ->
      from(f in Field, where: [schema_id: ^field.schema_id])
      |> where([f], f.ordering > ^field.ordering)
      |> repo.update_all(inc: [ordering: -1])
      |> then(fn res -> {:ok, res} end)
    end)
    |> Repo.transaction()
  end

  def mutation(%Service{filters: %{id: id}} = ctx) when not is_nil(id) do
    query(ctx)
    |> Repo.one
    |> case do
      nil -> {:error, "not_found"}
      entry ->
        Field.changeset(entry, ctx.changes)
        |> Repo.update
    end
  end
  def mutation(%Service{} = ctx) do
    %Field{
      user_id: ctx.user.id
    }
    |> Field.changeset(ctx.changes)
    |> Repo.insert
  end

  def mutation_ordering(%Service{changes: %{fields: fields}}) do
    field_map = Enum.into(fields, %{}, fn p ->
      {to_string(p.id), p.ordering}
    end)
    Multi.new
    |> Multi.run(:fields_update, fn _, _ ->
      from(p in Field)
      |> where([f], f.id in ^Map.keys(field_map))
      |> Repo.all
      |> Enum.map(fn f ->
        f
        |> Field.changeset(%{
          ordering: Map.get(field_map, to_string(f.id))
        })
        |> Repo.update
      end)
      |> Potionx.Utils.Ecto.reduce_results
    end)
    |> Multi.run(:fields, fn _, %{fields_update: fields} ->
      %{schema_id: schema_id} = Enum.at(fields, 0)

      update_ordering(
        from(q in Field)
        |> where([q], q.schema_id == ^schema_id)
      )
      |> Potionx.Utils.Ecto.reduce_results
    end)
    |> Repo.transaction
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one
  end

  def query(%Service{} = ctx) do
    Field
    |> search(ctx)
    |> where(
      ^(
        ctx.filters
        |> Map.to_list
      )
    )
    |> order_by([asc: :ordering, desc: :id])
  end
  def query(q, _args), do: q

  @doc """
  A search function that searches all string columns by default.
  """
  def search(query, %Service{search: nil}), do: query
  def search(query, %Service{search: ""}), do: query
  def search(query, %Service{search: s}) do
    clauses =
      Field.__schema__(:fields)
      |> Enum.reduce(nil, fn field_name, query ->
        if (Field.__schema__(:type, field_name) === :string) do
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

  def update_ordering(query, field \\ nil) do
    query
    |> exclude(:order_by)
    |> order_by([asc: :ordering])
    |> Repo.all
    |> (fn res ->
      case field do
        nil -> res
        field ->
          List.insert_at(res, field.ordering, field)
      end
    end).()
    |> Enum.with_index
    |> Enum.map(fn {val, ordering} ->
      val
      |> Field.changeset(%{ordering: ordering})
      |> Repo.update
    end)
  end
end
