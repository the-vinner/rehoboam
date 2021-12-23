defmodule Rehoboam.Repo.Migrations.CreateLocales do
  use Ecto.Migration

  def change do
    create table(:locales) do
      add(:locale, :string)
      add(:title, :string)

      timestamps()
    end

    create(unique_index(:locales, [:locale]))
  end
end
