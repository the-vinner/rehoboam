defmodule Rehoboam.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Rehoboam.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Rehoboam.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Rehoboam.DataCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Rehoboam.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end

  def create_entry(user) do
    ctx =
      %Potionx.Context.Service{
        user: user
      }
    schema = create_schema(user)
    {:ok, %{schema_published: schema_published}} =
      Rehoboam.Schemas.SchemaService.publish(%{
        ctx | filters: %{ id: schema.id }
      })
    {:ok, entry} = Rehoboam.Entries.EntryService.mutation(%{
      ctx |
        changes: Map.merge(
          Rehoboam.Entries.EntryMock.run(),
          %{
            schema_id: schema_published.id
          }
        )
    })

    entry
  end

  def create_schema(user) do
    ctx =
      %Potionx.Context.Service{
        changes: Rehoboam.Schemas.SchemaMock.run(),
        user: user
      }
    {:ok, schema} = Rehoboam.Schemas.SchemaService.mutation(ctx)
    schema
  end

  def create_user(email \\ "test@example.local") do
    Rehoboam.Users.UserService.mutation(%Potionx.Context.Service{
      changes: %{
        email: email,
        roles: [:admin],
        slug: "slug"
      }
    })
    |> (fn {:ok, %{user: user}} ->
          user
        end).()
  end

  def prepare_ctx(ctx) do
    user = create_user()

    %{
      ctx
      |
        locale: "en-US",
        roles: [:admin],
        session: %{
          id: 1,
          user: user
        },
        user: user
    }
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
