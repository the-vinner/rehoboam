defmodule Rehoboam.Schemas.SchemaService do
  alias Potionx.Context.Service
  alias Rehoboam.Schemas.Schema
  alias Rehoboam.Repo
  alias Ecto.Multi
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

  def clone(%Schema{} = schema) do
    %{
      schema
      | icon: nil,
        image: nil,
        is_latest: true,
        schema: nil,
        fields: [],
        master_schema_id: schema.id
    }
    |> Map.put(:id, nil)
    |> Map.drop([
      :user
    ])
    |> Ecto.Changeset.cast(
      %{
        fields: prep_fields(schema.fields)
      },
      []
    )
    |> Ecto.Changeset.cast_assoc(:fields, with: &Rehoboam.Schemas.Field.changeset_cast/2)
    |> Repo.insert()
  end

  def count(%Service{} = ctx) do
    from(item in query(ctx))
    |> select([i], count(i.id))
    |> exclude(:order_by)
    |> Repo.one!()
  end

  def delete(%Service{} = ctx) do
    one(ctx)
    |> case do
      {:ok, entry} ->
        entry
        |> Repo.delete()

      err ->
        err
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
    |> Schema.changeset(add_default_fields(ctx.changes, ctx.user.id))
    |> Repo.insert()
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
    |> case do
      nil -> {:error, "not_found"}
      res -> {:ok, res}
    end
  end

  def prep_fields(associations) do
    Enum.map(associations, fn assoc ->
      %{assoc | id: nil, master_field_id: assoc.id, schema_id: nil}
      |> Map.from_struct()
    end)
  end

  def publish(%Service{} = ctx) do
    Multi.new()
    |> Multi.run(:schema_master, fn _, _ ->
      query(ctx)
      |> preload([[fields: [:file, :image]], :image, :icon])
      |> Repo.one()
      |> case do
        nil ->
          {:error, "not_found"}

        schema ->
          published_at = DateTime.utc_now() |> DateTime.truncate(:second)

          Ecto.Changeset.change(schema, %{published_at: published_at})
          |> Repo.update()
      end
    end)
    |> Multi.run(:old_schemas_published, fn _, %{schema_master: schema} ->
      set_other_schemas_as_not_latest(schema.id)
    end)
    |> Multi.run(:schema_published, fn _, %{schema_master: master} ->
      clone(master)
    end)
    |> Repo.transaction()
  end

  def query(%Service{} = ctx) do
    locale = ctx.locale || ctx.locale_default

    Enum.reduce(ctx.filters, search(Schema, ctx),
      fn
        {:published, false}, q ->
          where(q, [q], is_nil(q.master_schema_id))
        {:published, true}, q ->
          where(q, [q], not is_nil(q.master_schema_id))
        _, q -> q
    end)
    |> where(
      ^(
        Map.take(ctx.filters, [:latest])
        |> Map.to_list()
      )
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

  def set_other_schemas_as_not_latest(master_schema_id) do
    from(
      s in Schema,
      where: s.master_schema_id == ^master_schema_id
    )
    |> Repo.update_all(set: [is_latest: false])
    |> then(fn res -> {:ok, res} end)
  end
end
