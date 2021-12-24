defmodule Rehoboam.Users.UserService do
  alias Potionx.Context.Service
  alias Rehoboam.Users.User
  alias Rehoboam.Repo
  import Ecto.Query

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
        |> User.changeset(%{})
        |> Ecto.Changeset.put_change(
          :deleted_at,
          DateTime.truncate(DateTime.utc_now(), :second)
        )
        |> Repo.update()
    end
  end

  def mutation(%Service{filters: %{id: id}} = ctx) when not is_nil(id) do
    Ecto.Multi.new()
    |> Rehoboam.Assets.FileService.mutation_multi(ctx)
    |> Ecto.Multi.run(:user, fn _, res ->
      query(ctx)
      |> Repo.one()
      |> case do
        nil ->
          {:error, "not_found"}

        entry ->
          User.changeset(
            entry,
            res
            |> case do
              %{file: %{id: file_id}} ->
                Map.put(ctx.changes, :file_id, file_id)

              _ ->
                ctx.changes
            end
          )
          |> Repo.update()
      end
    end)
    |> Repo.transaction()
  end

  def mutation(%Service{} = ctx) do
    Ecto.Multi.new()
    |> Rehoboam.Assets.FileService.mutation_multi(ctx)
    |> Ecto.Multi.run(:user, fn _, res ->
      %User{
        email: Map.get(ctx.changes, :email),
        file_id: Map.get(res[:file] || %{}, :id)
      }
      |> User.changeset(ctx.changes)
      |> Repo.insert()
    end)
    |> Repo.transaction()
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
  end

  def query(%Service{} = ctx) do
    User
    |> search(ctx)
    |> where(
      ^(ctx.filters
        |> Map.to_list())
    )
    |> order_by(desc: :id)
    |> where([u], is_nil(u.deleted_at))
  end

  def query(q, _args), do: q

  @doc """
  A search function that searches all string columns by default.
  """
  def search(query, %Service{search: nil}), do: query
  def search(query, %Service{search: ""}), do: query

  def search(query, %Service{search: s}) do
    query
    |> where(
      [u],
      fragment("(? || ' ' || ?) ILIKE ?", field(u, :name_first), field(u, :name_last), ^s) or
        ilike(u.slug, ^"#{s}%")
    )
  end

  def sign_in(%Service{} = ctx) do
    one(ctx)
    |> case do
      nil ->
        mutation(%Service{
          changes: ctx.changes
        })

      user ->
        user
    end
  end
end
