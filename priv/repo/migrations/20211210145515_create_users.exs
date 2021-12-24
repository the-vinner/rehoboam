defmodule Rehoboam.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "DROP EXTENSION IF EXISTS citext")

    create table(:users) do
      add(:bio, :text)
      add(:email, :citext, null: false)
      add(:deleted_at, :utc_datetime)
      add(:name_first, :string)
      add(:name_last, :string)
      add(:roles, {:array, :string})
      add(:slug, :text)
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:slug]))

    execute(
      "CREATE INDEX users_full_name_idx on users ((name_first || ' ' || name_last))",
      "DROP INDEX users_full_name_idx"
    )
  end
end
