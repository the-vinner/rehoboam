defmodule Rehoboam.Schemas.SchemaService do
  alias Potionx.Context.Service
  alias Rehoboam.Schemas.Schema
  alias Rehoboam.Repo
  import Ecto.Query

  def add_default_fields(changes, user_id) do
    fields =
      Rehoboam.Schemas.FieldDefaults.list()
      |> Enum.filter(fn field ->
        Enum.member?(
          [
            "title",
            "description",
            "images",
            "thumbnails"
          ],
          field.handle
        )
      end)
      |> Enum.with_index()
      |> Enum.map(fn {f, i} -> Map.from_struct(%{f | ordering: i, user_id: user_id}) end)

    Map.put(changes, :fields, fields)
  end

  def count(%Service{} = ctx) do
    from(item in query(ctx))
    |> select([i], count(i.id))
    |> exclude(:order_by)
    |> Repo.one!()
  end

  def delete(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "not_found"}

      entry ->
        entry
        |> Repo.delete()
    end
  end

  def get_published_schemas do
    from(s in Schema, where: s.is_latest)
    |> preload(:fields)
    |> Repo.all()
  end

  def mutation(%Service{filters: %{id: id}} = ctx) when not is_nil(id) do
    query(ctx)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "not_found"}

      entry ->
        Schema.changeset(entry, ctx.changes)
        |> Repo.update()
    end
  end

  def mutation(%Service{} = ctx) do
    %Schema{
      user_id: ctx.user.id
    }
    |> Schema.changeset(
      add_default_fields(ctx.changes, ctx.user.id)
    )
    |> Repo.insert()
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
  end

  def query(%Service{} = ctx) do
    locale = ctx.locale || ctx.locale_default

    Schema
    |> search(ctx)
    |> where(
      ^(ctx.filters
        |> Map.to_list())
    )
    |> order_by(
      desc: fragment("title_i18n->>?", ^to_string(locale)),
      desc: :id
    )
  end

  def query(q, _args), do: q

  @doc """
  A search function that searches all string columns by default.
  """
  def search(query, %Service{search: nil}), do: query
  def search(query, %Service{search: ""}), do: query

  def search(query, %Service{search: s}) do
    clauses =
      Schema.__schema__(:fields)
      |> Enum.reduce(nil, fn field_name, query ->
        if Schema.__schema__(:type, field_name) === :string do
          if query === nil do
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
